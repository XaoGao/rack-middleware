module Course
  RSpec.describe Application do
    let(:app) { described_class.new }

    context "when request to unhandle path" do
      let(:response) { get "/some_path" }

      # rubocop:disable RSpec/Rails/HaveHttpStatus
      it { expect(response.status).to eq(404) }
      # rubocop:enable RSpec/Rails/HaveHttpStatus
    end

    context "when GET request to root path" do
      let(:response) { get "/" }

      # rubocop:disable RSpec/Rails/HaveHttpStatus
      it { expect(response.status).to eq(200) }
      # rubocop:enable RSpec/Rails/HaveHttpStatus
      it { expect(response.body).to eq("root path!") }
    end

    context "when GET request to index path" do
      let(:response) { get "/index" }

      # rubocop:disable RSpec/Rails/HaveHttpStatus
      it { expect(response.status).to eq(200) }
      # rubocop:enable RSpec/Rails/HaveHttpStatus
      it { expect(response.body).to eq("Some index page") }
    end

    context "when POST request to create path" do
      let(:response) { post "/create" }

      # rubocop:disable RSpec/Rails/HaveHttpStatus
      it { expect(response.status).to eq(201) }
      # rubocop:enable RSpec/Rails/HaveHttpStatus
    end
  end
end
