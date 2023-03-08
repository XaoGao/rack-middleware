module Course
  module Middleware
    RSpec.describe Unsuccess do
      subject(:middleware) { described_class.new(app) }

      # rubocop:disable RSpec/VerifiedDoubles
      let(:app) { double(call: [Statuses::SUCSSESS, {}, ["Hello, World!"]]) }
      # rubocop:enable RSpec/VerifiedDoubles
      let(:env) { { "REQUEST_METHOD" => "GET", "REQUEST_PATH" => "/" } }
      let(:response) { middleware.call(env) }

      describe ".call" do
        context "when request is not handle middleware" do
          it { expect(response).to eq([Statuses::SUCSSESS, {}, ["Hello, World!"]]) }
        end

        context "when app return 404 status" do
          # rubocop:disable RSpec/VerifiedDoubles
          let(:app) { double(call: [Statuses::NOT_FOUND, {}, ["Hello, World!"]]) }
          # rubocop:enable RSpec/VerifiedDoubles

          it {
            expect(response).to eq([Statuses::NOT_FOUND, { "content-type" => "text/html" },
                                    [File.read(File.join(Course.config.root, "public", "404.html"))]])
          }
        end

        context "when app return 500 status" do
          # rubocop:disable RSpec/VerifiedDoubles
          let(:app) { double(call: [Statuses::INTERNAL_ERROR, {}, ["Hello, World!"]]) }
          # rubocop:enable RSpec/VerifiedDoubles

          it {
            expect(response).to eq([Statuses::INTERNAL_ERROR, { "content-type" => "text/html" },
                                    [File.read(File.join(Course.config.root, "public", "500.html"))]])
          }
        end
      end
    end
  end
end
