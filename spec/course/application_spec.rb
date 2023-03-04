RSpec.describe Course::Application do
  let(:app) { described_class.new }

  context "when request to root path" do
    let(:response) { get "/" }

    # rubocop:disable RSpec/Rails/HaveHttpStatus
    it { expect(response.status).to eq(200) }
    # rubocop:enable RSpec/Rails/HaveHttpStatus
    it { expect(response.body).to eq("Hello, World!") }
  end
end
