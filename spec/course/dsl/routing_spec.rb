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

          resources :post
        end
      end

      let(:dummy_instance) { dummy_class.new }

      describe ".get?" do
        let(:env_get) { { "REQUEST_METHOD" => "GET" } }
        let(:env_post) { { "REQUEST_METHOD" => "POST" } }

        it { expect(dummy_instance.get?(env_get)).to be true }
        it { expect(dummy_instance.get?(env_post)).to be false }
      end

      describe ".post?" do
        let(:env_get) { { "REQUEST_METHOD" => "GET" } }
        let(:env_post) { { "REQUEST_METHOD" => "POST" } }

        it { expect(dummy_instance.post?(env_post)).to be true }
        it { expect(dummy_instance.post?(env_get)).to be false }
      end

      describe ".put?" do
        let(:env_put) { { "REQUEST_METHOD" => "PUT" } }
        let(:env_post) { { "REQUEST_METHOD" => "POST" } }

        it { expect(dummy_instance.put?(env_put)).to be true }
        it { expect(dummy_instance.put?(env_post)).to be false }
      end

      describe ".delete?" do
        let(:env_delete) { { "REQUEST_METHOD" => "DELETE" } }
        let(:env_post) { { "REQUEST_METHOD" => "POST" } }

        it { expect(dummy_instance.delete?(env_delete)).to be true }
        it { expect(dummy_instance.delete?(env_post)).to be false }
      end

      describe "#list_of_get" do
        it {
          expect(dummy_class.list_of_get.map do |g|
                   g[0]
                 end).to eq(["/", "/index", "/posts", "/posts/new", "/posts/:id/edit", "/posts/:id"])
        }
      end

      describe "#list_of_post" do
        it { expect(dummy_class.list_of_post.map { |g| g[0] }).to eq(["/create", "/posts/:id"]) }
      end

      describe "#list_of_put" do
        it { expect(dummy_class.list_of_put.map { |g| g[0] }).to eq(["/posts/:id"]) }
      end

      describe "#list_of_delete" do
        it { expect(dummy_class.list_of_delete.map { |g| g[0] }).to eq(["/posts/:id"]) }
      end

      describe ".handle_request?" do
        let(:env_wrong) { { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/wrong_path" } }
        let(:env_get_index) { { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/index" } }

        it {
          expect(dummy_instance.handle_request?(env_get_index,
                                                dummy_class.list_of_get)[0]).to eq(env_get_index["PATH_INFO"])
        }

        it { expect(dummy_instance.handle_request?(env_wrong, dummy_class.list_of_get)).to be false }
      end

      describe "#get" do
        it "add a new get handler" do
          dummy_class.get("/some_get_path") { nil }
          expect(dummy_class.list_of_get.map do |g|
                   g[0]
                 end).to eq(["/", "/index", "/posts", "/posts/new", "/posts/:id/edit", "/posts/:id", "/some_get_path"])
        end
      end

      describe "#post" do
        it "add a new post handler" do
          dummy_class.post("/some_post_path") { nil }
          expect(dummy_class.list_of_post.map { |g| g[0] }).to eq(["/create", "/posts/:id", "/some_post_path"])
        end
      end

      describe "#put" do
        it "add a new put handler" do
          dummy_class.put("/some_put_path") { nil }
          expect(dummy_class.list_of_put.map { |g| g[0] }).to eq(["/posts/:id", "/some_put_path"])
        end
      end

      describe "#delete" do
        it "add a new delete handler" do
          dummy_class.delete("/some_delete_path") { nil }
          expect(dummy_class.list_of_delete.map { |g| g[0] }).to eq(["/posts/:id", "/some_delete_path"])
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
        let(:env_post) { { "REQUEST_METHOD" => "POST", "PATH_INFO" => "/create" } }
        let(:env_get_index) { { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/index" } }

        it { expect(dummy_instance.call(env_wrong)).to eq([500, {}, [""]]) }
        it { expect(dummy_instance.call(env_get_index)).to eq([200, {}, ["Some index page"]]) }
        it { expect(dummy_instance.call(env_post)).to eq([201, {}, [""]]) }
      end
    end
  end
end
