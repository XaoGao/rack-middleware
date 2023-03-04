RSpec.describe Course::Middleware::LoggerMiddleware do
  subject(:middleware) { described_class.new(app) }

  # rubocop:disable RSpec/VerifiedDoubles
  let(:app) { double(call: [200, {}, ["Hello, World!"]]) }
  # rubocop:enable RSpec/VerifiedDoubles
  let(:env) { { "REQUEST_METHOD" => "GET", "REQUEST_URI" => "/some_path?q=searched_str?value=123" } }

  describe ".call" do
    let(:logger) { instance_double(Logger, info: nil) }

    # TODO: think about how to send logger to construcors Course::Middleware::LoggerMiddleware
    # rubocop:disable RSpec/SubjectStub
    before do
      allow(middleware).to receive(:logger).and_return(logger)
    end
    # rubocop:enable RSpec/SubjectStub

    it "logger message" do
      middleware.call(env)
      expect(middleware.logger).to have_received(:info).with("#{env['REQUEST_METHOD']} #{env['REQUEST_URI']}").once
    end
  end
end
