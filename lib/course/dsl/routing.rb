module Course
  module DSL
    module Routing
      def self.included(base)
        base.extend(ClassMethods)
      end

      def call(env)
        return self.class.find_get_endpoint(env).call if handle_get_request?(env)
        return self.class.find_post_endpoint(env).call if handle_post_request?(env)
        return self.class.find_rack_app(env).new.call(env) if handle_other_rack_request?(env)

        [500, {}, [""]]
      end

      def handle_get_request?(env)
        return false unless get?(env)

        self.class.list_of_get.any? { |item| item[0] == env["PATH_INFO"] }
      end

      def handle_post_request?(env)
        return false unless post?(env)

        self.class.list_of_post.any? { |item| item[0] == env["PATH_INFO"] }
      end

      def handle_other_rack_request?(env)
        self.class.other_rack_app.any? { |item| env["PATH_INFO"].start_with?(item[0]) }
      end

      def get?(env)
        env["REQUEST_METHOD"] == "GET"
      end

      def post?(env)
        env["REQUEST_METHOD"] == "POST"
      end

      module ClassMethods
        def find_get_endpoint(env)
          list_of_get.find { |item| item[0] == env["PATH_INFO"] }[1]
        end

        def find_post_endpoint(env)
          list_of_post.find { |item| item[0] == env["PATH_INFO"] }[1]
        end

        def find_rack_app(env)
          other_rack_app.find { |item| env["PATH_INFO"].start_with?(item[0]) }[1]
        end

        def get(url, &block)
          list_of_get << [url, block]
        end

        def post(url, &block)
          list_of_post << [url, block]
        end

        def mount(url, rack_app)
          raise ArgumentError "rack_app can not be nil" if rack_app.nil?

          other_rack_app << [url, rack_app]
        end

        def list_of_get
          @list_of_get ||= []
        end

        def list_of_post
          @list_of_post ||= []
        end

        def other_rack_app
          @other_rack_app ||= []
        end
      end
    end
  end
end
