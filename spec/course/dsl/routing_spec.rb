module Course
  module DSL
    RSpec.describe Routing do
      let(:dummy_class) do
        Class.new do
          include Routing

          get "/" do
            [200, {}, ["root path!"]]
          end

          get "/index" do
            [200, {}, ["Some index page"]]
          end

          post "/create" do
            [201, {}, [""]]
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

      describe "#find_get_endpoint" do
        it "find a get handler by url" do
          result = dummy_class.find_get_endpoint(env_get_index)
          expect(result.call).to eq([200, {}, ["Some index page"]])
        end
      end

      describe "#find_post_endpoint" do
        it "find a get handler by url" do
          result = dummy_class.find_post_endpoint(env_post)
          expect(result.call).to eq([201, {}, [""]])
        end
      end

      describe ".handle_get_request?" do
        let(:env_wrong) { { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/wrong_path" } }

        it { expect(dummy_instance.handle_get_request?(env_get_index)).to be true }
        it { expect(dummy_instance.handle_get_request?(env_wrong)).to be false }
      end

      describe ".handle_post_request?" do
        let(:env_wrong) { { "REQUEST_METHOD" => "POST", "PATH_INFO" => "/wrong_path" } }

        it { expect(dummy_instance.handle_post_request?(env_post)).to be true }
        it { expect(dummy_instance.handle_post_request?(env_wrong)).to be false }
      end

      describe ".call" do
        let(:env_wrong) { { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/wrong_path" } }

        it { expect(dummy_instance.call(env_wrong)).to eq([404, {}, [""]]) }
        it { expect(dummy_instance.call(env_get_index)).to eq([200, {}, ["Some index page"]]) }
        it { expect(dummy_instance.call(env_post)).to eq([201, {}, [""]]) }
      end
    end
  end
end
