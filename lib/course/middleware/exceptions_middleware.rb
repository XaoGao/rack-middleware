module Course
  module Middleware
    class ExceptionsMiddleware
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = app.call(env)
        [status, headers, body]
      rescue StandardError => _e
        [500, { "content-type" => "text/plain" }, ["unexpected error, try again"]]
      end
    end
  end
end
