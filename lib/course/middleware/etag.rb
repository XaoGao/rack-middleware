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
          hash_body = digest_body(body)
          headers["etag"] = hash_body
        end

        [status, headers, body]
      end

      private

      def success_status?(status)
        status == 200
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
