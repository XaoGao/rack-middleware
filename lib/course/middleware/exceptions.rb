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
      rescue Exception => e
        unless env["logger"].nil?
          env["logger"].error e.message
          env["logger"].error e.backtrace
        end

        type = content_type_request_or_default(env)
        [Statuses::INTERNAL_ERROR, { "content-type" => type }, [""]]
      end
      # rubocop:enable Lint/RescueException

      private

      def content_type_request_or_default(env)
        env["CONTENT_TYPE"] || "text/html"
      end
    end
  end
end
