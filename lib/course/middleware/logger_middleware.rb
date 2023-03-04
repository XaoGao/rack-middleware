require "logger"

module Course
  module Middleware
    class LoggerMiddleware
      attr_reader :app, :logger

      def initialize(app)
        @app = app
        @logger = Logger.new($stdout)
      end

      def call(env)
        logger.info("#{env['REQUEST_METHOD']} #{env['REQUEST_URI']}")
        status, headers, body = @app.call(env)
        [status, headers, body]
      end
    end
  end
end
