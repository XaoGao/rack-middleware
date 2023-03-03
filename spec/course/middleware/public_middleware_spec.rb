RSpec.describe Course::Middleware::PublicMiddleware do
  subject(:middleware) { described_class.new(app) }

  # rubocop:disable RSpec/VerifiedDoubles
  let(:app) { double(call: [200, {}, ["Hello, World!"]]) }
  # rubocop:enable RSpec/VerifiedDoubles
  let(:env) { { "REQUEST_METHOD" => "GET", "REQUEST_PATH" => "/" } }
  let(:response) { middleware.call(env) }

  describe ".call" do
    context "when request is not handle middleware" do
      it { expect(response).to eq([200, {}, ["Hello, World!"]]) }
    end

    context "when request is handle middleware" do
      let(:env) { { "REQUEST_METHOD" => "GET", "REQUEST_PATH" => "/public/xml_file.xml" } }
      let(:body) do
        <<~XML
          <root>\n  <plate>zoo</plate>\n  <every>894785129.1519098</every>\n  <to>\n    <church>1499934632.6463704</church>\n    <along>-1503535372.1836905</along>\n    <surface>1257511142.7794971</surface>\n    <golden>\n      <body>brain</body>\n      <potatoes>-931076515.3095288</potatoes>\n      <contrast>fear</contrast>\n      <shallow>-1687739721.8787646</shallow>\n      <faster>it</faster>\n      <visitor>661860075</visitor>\n    </golden>\n    <upper>\n      <eager>drawn</eager>\n      <toward>-838798072.4823685</toward>\n      <differ>-1560007650</differ>\n      <frozen>recent</frozen>\n      <fog>1176422055.264957</fog>\n      <eventually>ranch</eventually>\n    </upper>\n    <national>hand</national>\n  </to>\n  <rocky>1009957856</rocky>\n  <center>maybe</center>\n  <local>-1142268255.0697827</local>\n</root>
        XML
      end

      it { expect(response[0]).to eq(200) }
      it { expect(response[2].first).to eq(body) }
    end

    context "when source is not found" do
      let(:env) { { "REQUEST_METHOD" => "GET", "REQUEST_PATH" => "/public/frong_file.xml" } }

      it { expect(response).to eq([404, { "content-type" => "text/plain" }, ["Source not found"]]) }
    end
  end
end
