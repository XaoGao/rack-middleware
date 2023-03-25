module Course
  class OtherRackApp
    include DSL::Routing

    get "/rack_app" do
      status(200)
      result = ""
      ObjectSpace.each_object(Class)
                 .select { |c| c.included_modules.include? DSL::Routing }
                 .each do |klass|
        %I[get post put delete].each do |method|
          result += "#{method}\n"
          klass.send("list_of_#{method}").each do |path|
            result += "#{path[0]}\n"
          end
        end
      end
      result
    end

    get "/rack_app/index" do
      status(200)
      "other rack index"
    end
  end
end
