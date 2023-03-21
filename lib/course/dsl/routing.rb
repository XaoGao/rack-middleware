module Course
  module DSL
    module Routing
      def self.included(base)
        base.extend(ClassMethods)
      end

      # rubocop:disable Metrics/AbcSize
      def call(env)
        result = get?(env) && handle_request?(env, self.class.list_of_get)
        body = self.class.find_endpoint(self.class.list_of_get, result.join("/")).call if result
        result = post?(env) && handle_request?(env, self.class.list_of_post)
        body = self.class.find_endpoint(self.class.list_of_post, result.join("/")).call if result
        return [self.class.status_or_default, self.class.headers_or_default, [body || ""]] unless body.nil?

        return self.class.find_rack_app(env).new.call(env) if handle_other_rack_request?(env)

        [500, {}, [""]]
      end
      # rubocop:enable Metrics/AbcSize

      def handle_request?(env, list)
        arr_request_path = env["PATH_INFO"].split("/")
        list.each do |path|
          arr_path = path[0].split("/")
          next if arr_path.size != arr_request_path.size

          find_url = match(arr_path, arr_request_path)
          next if find_url.nil?

          find_params(arr_request_path, find_url)
          return find_url
        end
        false
      end

      def match(arr_path, arr_request_path)
        arr_path.each_with_index do |_, i|
          next if arr_path[i].include?(":")
          return nil if arr_path[i] != arr_request_path[i]
        end
        arr_path
      end

      def find_params(arr_request_path, find_url)
        self.class.params = {}
        find_url.each_with_index do |_, i|
          self.class.params[find_url[i]] = arr_request_path[i] if find_url[i].include?(":")
        end
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
        def find_endpoint(list, url)
          list.find { |item| item[0] == url }[1]
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

        def params
          @params ||= {}
        end

        def params=(value)
          @params = value
        end

        def headers(hash)
          @headers = hash
        end

        def status(code)
          @status = code
        end

        def status_or_default
          @status || 500
        end

        def headers_or_default
          @headers || {}
        end
      end
    end
  end
end
