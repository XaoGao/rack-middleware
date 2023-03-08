require "logger"

module Course
  module Middleware
    class Logger
      attr_reader :app, :logger

      def initialize(app, logger:)
        raise ArgumentError, "logger can not be nil" if logger.nil?

        @app = app
        @logger = logger
      end

      def call(env)
        env["logger"] = logger
        logger.info("#{env['REQUEST_METHOD']} #{env['REQUEST_URI']}")
        app.call(env)
      end
    end
  end
end
