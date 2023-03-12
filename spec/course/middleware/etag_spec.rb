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
          it { expect(response).to eq([Statuses::SUCCESS, {}, ["Hello, World!"]]) }
        end

        context "when response have cache header" do
          let(:headers) { { "cache-control" => "public, max-age=31_536_000" } }
          let(:digest) { Digest::MD5.hexdigest(["Hello, World!"].compact.to_s) }

          it { expect(response[1]).to include("etag" => digest) }
          it { expect(response[0]).to eq(200) }
        end

        context "when response already have etag header" do
          let(:headers) { { "cache-control" => "public, max-age=31_536_000", "etag" => digest } }
          let(:digest) { Digest::MD5.hexdigest(["Hello, World!"].compact.to_s) }

          it { expect(response[1]).to include("etag" => digest) }
          it { expect(response[0]).to eq(304) }
        end

        context "when response already have wrong etag header" do
          let(:headers) { { "cache-control" => "public, max-age=31_536_000", "etag" => "some hex" } }
          let(:digest) { Digest::MD5.hexdigest(["Hello, World!"].compact.to_s) }

          it { expect(response[1]).to include("etag" => digest) }
          it { expect(response[0]).to eq(200) }
        end
      end
    end
  end
end
