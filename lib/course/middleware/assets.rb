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
        if danger_path?(env)
          return [Statuses::NOT_FOUND, { "content-type" => (env["CONTENT_TYPE"] || "text/plain") }, [""]]
        end

        body = read_file(env)
        status = body == "" ? Statuses::NOT_FOUND : Statuses::SUCSSESS
        [status, headers(env), [body]]
      end

      def read_file(env)
        full_path_to_file = full_path(env)
        if File.file?(full_path_to_file)
          File.read(full_path_to_file)
        else
          ""
        end
      end

      def full_path(env)
        file_name = env["REQUEST_PATH"].sub(PUBLIC_URL, "")
        File.join(assets_path, file_name)
      end

      def danger_path?(env)
        env["REQUEST_PATH"].sub(PUBLIC_URL, "").include?("../")
      end

      def headers(env)
        header = {}
        header["content-type"] = env["CONTENT_TYPE"] || "text/plain"
        header["cache-control"] = "public, max-age=#{MAX_CACHE_AGE}"
        header["expires"] = (Time.now + MAX_CACHE_AGE).utc.rfc2822

        header
      end
    end
  end
end