module Course
  class Application
    include DSL::Routing

    get "/" do
      [200, {}, ["root path!"]]
    end

    get "/index" do
      [200, {}, ["Some index page"]]
    end

    post "/create" do
      [201, {}, [""]]
    end

    mount "/rack_app", OtherRackApp
  end
end
