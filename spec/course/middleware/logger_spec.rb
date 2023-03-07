module Course
  module Middleware
    RSpec.describe Logger do
      subject(:middleware) { described_class.new(app, logger:) }

      # rubocop:disable RSpec/VerifiedDoubles
      let(:app) { double(call: [200, {}, ["Hello, World!"]]) }
      # rubocop:enable RSpec/VerifiedDoubles
      let(:env) { { "REQUEST_METHOD" => "GET", "REQUEST_URI" => "/some_path?q=searched_str?value=123" } }
      let(:logger) { instance_double(::Logger, info: nil) }

      describe ".call" do
        it "logger message" do
          middleware.call(env)
          expect(middleware.logger).to have_received(:info).with("#{env['REQUEST_METHOD']} #{env['REQUEST_URI']}").once
        end
      end
    end
  end
end
