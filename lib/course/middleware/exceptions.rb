module Course
  module Middleware
    class Exceptions
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def call(env)
        app.call(env)
      # rubocop:disable Lint/RescueException
      rescue Exception
        type = content_type_request_or_default(env)
        [500, { "content-type" => type }, ["unexpected error, try again"]]
      end
      # rubocop:enable Lint/RescueException

      private

      def content_type_request_or_default(env)
        env["CONTENT_TYPE"] || "text/plain"
      end
    end
  end
end
