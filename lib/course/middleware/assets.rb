module Course
  module Middleware
    class Assets
      attr_reader :app, :assets_path

      REQUEST_METHOD_GET = "GET".freeze
      PUBLIC_URL = "/public".freeze
      MAX_CACHE_AGE = 31_536_000

      def initialize(app, path_to_assets: Course.config.assets_path)
        @app = app
        @assets_path = path_to_assets
      end

      def call(env)
        if get?(env) && public_url?(env)
          handle_public_request(env)
        else
          app.call(env)
        end
      end

      private

      def get?(env)
        env["REQUEST_METHOD"] == REQUEST_METHOD_GET
      end

      def public_url?(env)
        env["REQUEST_PATH"].start_with?(PUBLIC_URL)
      end

      def handle_public_request(env)
        return [Statuses::NOT_FOUND, { "content-type" => (env["CONTENT_TYPE"]) }, [""]] if danger_path?(env)

        if file_exist?(env)
          body = read_file(env)
          [Statuses::SUCCESS, headers(env), [body]]
        else
          [Statuses::NOT_FOUND, {}, [""]]
        end
      end

      def file_exist?(env)
        File.file?(full_path(env))
      end

      def read_file(env)
        File.read(full_path(env))
      end

      def full_path(env)
        file_name = env["REQUEST_PATH"].sub(PUBLIC_URL, "")
        File.join(assets_path, file_name)
      end

      def danger_path?(env)
        env["REQUEST_PATH"].sub(PUBLIC_URL, "").include?("../")
      end

      def headers(env)
        {
          "content-type" => env["CONTENT_TYPE"],
          "cache-control" => "public, max-age=#{MAX_CACHE_AGE}",
          "expires" => (Time.now + MAX_CACHE_AGE).utc.rfc2822
        }
      end
    end
  end
end
