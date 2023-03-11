module Course
  module Middleware
    RSpec.describe Etag do
      subject(:middleware) { described_class.new(app) }

      # rubocop:disable RSpec/VerifiedDoubles
      let(:app) { double(call: [200, headers, ["Hello, World!"]]) }
      # rubocop:enable RSpec/VerifiedDoubles
      let(:headers) { {} }

      let(:env) { { "REQUEST_METHOD" => "GET", "REQUEST_PATH" => "/" } }
      let(:response) { middleware.call(env) }

      describe ".call" do
        context "when response is not handle middleware" do
          it { expect(response).to eq([Statuses::SUCSSESS, {}, ["Hello, World!"]]) }
        end

        context "when response have cache header" do
          let(:headers) { { "cache-control" => "public, max-age=31_536_000" } }
          let(:digest) { Digest::MD5.hexdigest("Hello, World!") }

          it "have etag header" do
            expect(response[1]).to include("etag" => digest)
          end
        end
      end
    end
  end
end
