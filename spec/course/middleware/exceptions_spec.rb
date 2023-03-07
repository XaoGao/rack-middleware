module Course
  module Middleware
    RSpec.describe Exceptions do
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

        context "when app raise exception" do
          before do
            allow(app).to receive(:call).and_raise(StandardError)
          end

          it { expect(response).to eq([500, { "content-type" => "text/plain" }, ["unexpected error, try again"]]) }
        end
      end
    end
  end
end
