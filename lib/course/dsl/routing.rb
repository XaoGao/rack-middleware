require "mustermann"

module Course
  module DSL
    module Routing
      def self.included(base)
        base.extend(ClassMethods)
      end

      def call(env)
        %I[get post put delete].each do |method|
          result = method_and_handle_request?(method, env)
          if result
            body = result[1].call
            return [self.class.status_or_default, self.class.headers_or_default, [body || ""]]
          end
        end

        return self.class.find_rack_app(env).new.call(env) if handle_other_rack_request?(env)

        [Statuses::INTERNAL_ERROR, {}, [""]]
      end

      def method_and_handle_request?(method, env)
        send("#{method}?".to_sym, env) && handle_request?(env, self.class.send("list_of_#{method}"))
      end

      def handle_request?(env, list)
        request_path = env["PATH_INFO"]
        list.each do |path|
          pattern = Mustermann.new(path[0])
          if request_path =~ Mustermann.new(pattern)
            self.class.params = pattern.params(request_path)
            return path
          end
        end
        false
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

      def put?(env)
        env["REQUEST_METHOD"] == "PUT"
      end

      def delete?(env)
        env["REQUEST_METHOD"] == "DELETE"
      end

      module ClassMethods
        def find_rack_app(env)
          other_rack_app.find { |item| env["PATH_INFO"].start_with?(item[0]) }[1]
        end

        %I[get post put delete].each do |method|
          # rubocop:disable Security/Eval
          eval <<-LIST, binding, __FILE__, __LINE__ + 1
            def list_of_#{method}        # def list_of_get
              @list_of_#{method} ||= []  #   @list_of_get ||= []
            end                          # end
          LIST
          # rubocop:enable Security/Eval
          define_method(method) do |url, &block|
            send("list_of_#{method}") << [url, block]
          end
        end

        def mount(url, rack_app)
          raise ArgumentError "rack_app can not be nil" if rack_app.nil?

          other_rack_app << [url, rack_app]
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

        def resources(source_name, options = {})
          verbs = %I[index new edit show create update destroy]
          if options.include?(:except) && options.include?(:only)
            raise ArgumentError ":except and :only options can not be used together"
          end

          verbs -= options[:except] if options.include?(:except)
          verbs = options[:only] if options.include?(:only)

          plur = source_name.to_s.pluralize
          verbs.each do |verb|
            send("scaffold_#{verb}", verb, source_name, plur)
          end
        end

        def scaffold_index(verb, _, plur)
          return unless verb == :index

          get("/#{plur}") do
            status(200)
            "#{plur} index page"
          end
        end

        def scaffold_new(verb, source_name, plur)
          return unless verb == :new

          get("/#{plur}/new") do
            status(200)
            "#{source_name} new page"
          end
        end

        def scaffold_create(verb, source_name, plur)
          return unless verb == :create

          post("/#{plur}/:id") do
            status(200)
            "#{source_name} create page"
          end
        end

        def scaffold_edit(verb, source_name, plur)
          return unless verb == :edit

          get("/#{plur}/:id/edit") do
            status(200)
            "#{source_name} new page"
          end
        end

        def scaffold_update(verb, source_name, plur)
          return unless verb == :update

          put("/#{plur}/:id") do
            status(200)
            "#{source_name} edit page"
          end
        end

        def scaffold_show(verb, source_name, plur)
          return unless verb == :show

          get("/#{plur}/:id") do
            status(200)
            "#{source_name} show page"
          end
        end

        def scaffold_destroy(verb, source_name, plur)
          return unless verb == :destroy

          delete("/#{plur}/:id") do
            status(200)
            "#{source_name} destroy page"
          end
        end
      end
    end
  end
end
