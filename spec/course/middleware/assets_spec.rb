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
          it { expect(response).to eq([200, {}, ["Hello, World!"]]) }
        end

        context "when request is handle middleware" do
          let(:env) { { "REQUEST_METHOD" => "GET", "REQUEST_PATH" => "/public/xml_file.xml" } }
          let(:body) do
            File.read(File.join(Course.config.root, "public", "assets", "xml_file.xml"))
          end

          it { expect(response[0]).to eq(200) }
          it { expect(response[2].first).to eq(body) }
        end

        context "when source is not found" do
          let(:env) { { "REQUEST_METHOD" => "GET", "REQUEST_PATH" => "/public/frong_file.xml" } }

          it { expect(response).to eq([404, { "content-type" => "text/plain" }, ["Source not found"]]) }
        end

        context "when path traversal" do
          let(:env) { { "REQUEST_METHOD" => "GET", "REQUEST_PATH" => "/public/../../../docker-compose.yml" } }

          it { expect(response).to eq([404, { "content-type" => "text/plain" }, ["Source not found"]]) }
        end
      end
    end
  end
end
