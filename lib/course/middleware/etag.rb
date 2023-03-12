module Course
  module Middleware
    class Etag
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = app.call(env)

        if success_status?(status) && cache?(headers)
          digest = digest_body(body)
          return [Statuses::NOT_MODIFIED, headers, body] if headers["etag"] == digest

          headers["etag"] = digest
          return [status, headers, body]
        end

        [status, headers, body]
      end

      private

      def success_status?(status)
        status == Statuses::SUCSSESS
      end

      def cache?(headers)
        headers.include? "cache-control"
      end

      # body is an array
      def digest_body(body)
        body.filter { |item| !item.empty? }
            .reduce("") { |res, item| res + Digest::MD5.hexdigest(item) }
      end
    end
  end
end
