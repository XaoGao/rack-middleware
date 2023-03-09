module Course
  module Middleware
    RSpec.describe Exceptions do
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

        context "when app raise exception" do
          before do
            allow(app).to receive(:call).and_raise(StandardError)
          end

          it { expect(response).to eq([Statuses::INTERNAL_ERROR, { "content-type" => "text/html" }, [""]]) }
        end

        context "when app raise exception with content type" do
          before do
            allow(app).to receive(:call).and_raise(StandardError)
          end

          let(:env) { { "REQUEST_METHOD" => "GET", "REQUEST_PATH" => "/", "CONTENT_TYPE" => "application/xml" } }

          it { expect(response).to eq([Statuses::INTERNAL_ERROR, { "content-type" => "application/xml" }, [""]]) }
        end
      end
    end
  end
end
