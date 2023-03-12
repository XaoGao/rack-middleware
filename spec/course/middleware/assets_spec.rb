module Course
  module Middleware
    RSpec.describe Assets do
      subject(:middleware) { described_class.new(app) }

      # rubocop:disable RSpec/VerifiedDoubles
      let(:app) { double(call: [200, {}, ["Hello, World!"]]) }
      # rubocop:enable RSpec/VerifiedDoubles
      let(:env) { { "REQUEST_METHOD" => "GET", "REQUEST_PATH" => "/" } }
      let(:response) { middleware.call(env) }

      describe ".call" do
        context "when request is not handle middleware" do
          it { expect(response).to eq([Statuses::SUCCESS, {}, ["Hello, World!"]]) }
        end

        context "when request is handle middleware" do
          let(:env) { { "REQUEST_METHOD" => "GET", "REQUEST_PATH" => "/public/xml_file.xml" } }
          let(:body) do
            File.read(File.join(Course.config.root, "public", "assets", "xml_file.xml"))
          end

          it { expect(response[0]).to eq(Statuses::SUCCESS) }
          it { expect(response[2].first).to eq(body) }
        end

        context "when source is not found" do
          let(:env) { { "REQUEST_METHOD" => "GET", "REQUEST_PATH" => "/public/frong_file.xml" } }
          let(:expires) { (Time.now + described_class::MAX_CACHE_AGE).utc.rfc2822 }

          it {
            expect(response).to eq([Statuses::NOT_FOUND, {}, [""]])
          }
        end

        context "when path traversal" do
          let(:env) do
            {
              "CONTENT_TYPE" => "applications/xml",
              "REQUEST_METHOD" => "GET",
              "REQUEST_PATH" => "/public/../../../docker-compose.yml"
            }
          end

          it { expect(response).to eq([Statuses::NOT_FOUND, { "content-type" => "applications/xml" }, [""]]) }
        end
      end
    end
  end
end
