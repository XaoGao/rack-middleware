RSpec.describe RackMiddlware::Application do
  let(:app) { RackMiddlware::Application.new }

  context "when request to root path" do
    let(:response) { get "/" }

    it { expect(response.status).to eq(200) }
    it { expect(response.body).to eq("Hello, World!") }
  end
end
