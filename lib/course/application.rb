module Course
  class Application
    include DSL::Routing

    get "/" do
      status(200)
      "root path!"
    end

    get "/index" do
      status(200)
      "Some index page"
    end

    get "/projects/:id/tasks/:name" do
      status(200)
      ""
    end

    post "/create" do
      status(201)
      ""
    end

    mount "/rack_app", OtherRackApp
  end
end
