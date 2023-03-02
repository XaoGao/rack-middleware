module Course
  class Application
    def call(_)
      [200, {}, ["Hello, World!"]]
    end
  end
end
