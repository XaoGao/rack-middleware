module Course
  module Middleware
    class Unsuccess
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)
        if handled_status?(status)
          body = public_page(status)
          headers["content-type"] = "text/html" if headers["content-type"].nil?
        end

        [status, headers, body]
      end

      private

      def handled_status?(status)
        [Statuses::NOT_FOUND, Statuses::INTERNAL_ERROR].include? status
      end

      def public_page(status)
        [File.read(File.join(Course.config.root, "public", "#{status}.html"))]
      end
    end
  end
end
