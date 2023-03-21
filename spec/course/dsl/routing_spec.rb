module Course
  module DSL
    RSpec.describe Routing do
      let(:dummy_class) do
        Class.new do
          include Routing

          get "/" do
            status(200)
            headers({})
            "root path!"
          end

          get "/index" do
            status(200)
            headers({})
            "Some index page"
          end

          post "/create" do
            status(201)
            headers({})
            ""
          end
        end
      end

      let(:dummy_instance) { dummy_class.new }

      let(:env_get) { { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/" } }
      let(:env_get_index) { { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/index" } }
      let(:env_post) { { "REQUEST_METHOD" => "POST", "PATH_INFO" => "/create" } }

      describe ".get?" do
        it { expect(dummy_instance.get?(env_get)).to be true }
        it { expect(dummy_instance.post?(env_get)).to be false }
      end

      describe ".post?" do
        it { expect(dummy_instance.get?(env_post)).to be false }
        it { expect(dummy_instance.post?(env_post)).to be true }
      end

      describe "#list_of_get" do
        it { expect(dummy_class.list_of_get.map { |g| g[0] }).to eq(["/", "/index"]) }
      end

      describe "#list_of_post" do
        it { expect(dummy_class.list_of_post.map { |g| g[0] }).to eq(["/create"]) }
      end

      describe ".match" do
        let(:arr_path) { "/projects/:id/tasks/:name".split("/") }
        let(:arr_request_path) { "/projects/10/tasks/test".split("/") }

        it { expect(dummy_instance.match(arr_path, arr_request_path)).to eq(arr_path) }

        it "will not match" do
          arr_path = "/projects/:id/tasks/:name/index".split("/")
          expect(dummy_instance.match(arr_path, arr_request_path)).to be_nil
        end
      end

      describe ".find_params" do
        let(:arr_request_path) { "/projects/:id/tasks/:name".split("/") }
        let(:find_url) { "/projects/10/tasks/test".split("/") }

        it "set params" do
          dummy_instance.find_params(arr_request_path, find_url)
          expect(dummy_class.params).to eq({})
        end
      end

      describe ".handle_request?" do
        let(:env_wrong) { { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/wrong_path" } }

        it {
          expect(dummy_instance.handle_request?(env_get_index,
                                                dummy_class.list_of_get)).to eq(env_get_index["PATH_INFO"].split("/"))
        }

        it { expect(dummy_instance.handle_request?(env_wrong, dummy_class.list_of_get)).to be false }
      end

      describe "#get" do
        it "add a new get handler" do
          dummy_class.get("/some_get_path") do
            nil
          end
          expect(dummy_class.list_of_get.map { |g| g[0] }).to eq(["/", "/index", "/some_get_path"])
        end
      end

      describe "#post" do
        it "add a new post handler" do
          dummy_class.post("/some_post_path") do
            nil
          end
          expect(dummy_class.list_of_post.map { |g| g[0] }).to eq(["/create", "/some_post_path"])
        end
      end

      describe "#find_endpoint" do
        it "find a get handler by url" do
          result = dummy_class.find_endpoint(dummy_class.list_of_get, "/index")
          expect(result.call).to eq("Some index page")
        end
      end

      describe ".status_or_default" do
        it { expect(dummy_class.status_or_default).to eq(500) }

        it "seted status" do
          dummy_class.status(200)
          expect(dummy_class.status_or_default).to eq(200)
        end
      end

      describe ".headers_or_default" do
        it { expect(dummy_class.headers_or_default).to eq({}) }

        it "seted status" do
          dummy_class.headers({ "content-type" => "applications/json" })
          expect(dummy_class.headers_or_default).to eq({ "content-type" => "applications/json" })
        end
      end

      describe ".call" do
        let(:env_wrong) { { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/wrong_path" } }

        it { expect(dummy_instance.call(env_wrong)).to eq([500, {}, [""]]) }
        it { expect(dummy_instance.call(env_get_index)).to eq([200, {}, ["Some index page"]]) }
        it { expect(dummy_instance.call(env_post)).to eq([201, {}, [""]]) }
      end
    end
  end
end
