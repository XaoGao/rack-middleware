module Course
  module Middleware
    class Unsuccess
      attr_reader :app

      NOT_FOUND_STATUS = 404
      INTERNAL_ERROR = 500

      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)
        if handled_status?(status)
          body = public_page(status)
          headers = { "content-type" => "text/html" }
        end

        [status, headers, body]
      end

      private

      def handled_status?(status)
        [NOT_FOUND_STATUS, INTERNAL_ERROR].include? status
      end

      def public_page(status)
        File.read(File.join(Course.config.root, "public", "#{status}.html"))
      end
    end
  end
end
