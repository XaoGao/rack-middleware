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
        [500, { "content-type" => "text/plain" }, ["unexpected error, try again"]]
      end
      # rubocop:enable Lint/RescueException
    end
  end
end
