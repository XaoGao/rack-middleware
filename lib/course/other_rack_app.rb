module Course
  class OtherRackApp
    include DSL::Routing

    get "/rack_app" do
      [200, {}, ["other rack"]]
    end

    get "/rack_app/index" do
      [200, {}, ["other rack index"]]
    end
  end
end
