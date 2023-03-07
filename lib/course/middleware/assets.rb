module Course
  module Middleware
    class Assets
      attr_reader :app

      REQUEST_METHOD_GET = "GET".freeze
      PUBLIC_URL = "/public".freeze

      def initialize(app)
        @app = app
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
        return [404, { "content-type" => "text/plain" }, ["Source not found"]] if danger_path?(env)

        body = read_file(env)
        status = body == "Source not found" ? 404 : 200
        # TODO: add factory to generate contetnt-type
        [status, { "content-type" => "text/plain" }, [body]]
      end

      def read_file(env)
        full_path_to_file = full_path(env)
        if File.file?(full_path_to_file)
          File.read(full_path_to_file)
        else
          "Source not found"
        end
      end

      def full_path(env)
        file_name = env["REQUEST_PATH"].sub(PUBLIC_URL, "")
        File.join(Course.config.root, "public", "assets", file_name)
      end

      def danger_path?(env)
        env["REQUEST_PATH"].sub(PUBLIC_URL, "").include?("../")
      end
    end
  end
end
