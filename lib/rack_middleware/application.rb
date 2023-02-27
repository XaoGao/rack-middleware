module RackMiddleware
  class Application
    # rubocop:disable Lint/UnusedMethodArgument
    def call(env)
      [200, {}, ["Hello, World!"]]
    end
    # rubocop:enable Lint/UnusedMethodArgument
  end
end
