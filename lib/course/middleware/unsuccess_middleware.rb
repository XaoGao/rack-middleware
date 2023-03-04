module Course
  module Middleware
    class UnsuccessMiddleware
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)
        if [404, 500].include? status
          body = public_page(status)
          headers = { "content-type" => "text/html" }
        end

        [status, headers, body]
      end

      private

      def public_page(status)
        File.read(File.join(File.dirname(__FILE__), "..", "..", "public", "#{status}.html"))
      end
    end
  end
end
