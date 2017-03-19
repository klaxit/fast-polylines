require "spec_helper"

describe FastPolylines::Decoder do
  describe ".decode" do
    let(:points) { [[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]] }
    context "with default precision" do
      let(:polyline) { "_p~iF~ps|U_ulLnnqC_mqNvxq`@" }
      it "should decode a polyline correctly" do
        expect(described_class.decode(polyline)).to eq points
      end
      it "should perform at least 5x faster than the Polylines gem" do
        expect {
          described_class.decode(polyline)
        }.to perform_faster_than {
          Polylines::Decoder.decode_polyline(polyline)
        }.at_least(5).times
      end
    end
    context "with 1e6 precision" do
      let(:polyline) { "_izlhA~rlgdF_{geC~ywl@_kwzCn`{nI" }
      it "should decode a polyline correctly" do
        expect(described_class.decode(polyline, 1e6)).to eq points
      end
    end
    context "with points that were close together" do
      let(:points) { [[41.35222, -86.04563], [41.35222, -86.04544]] }
      it "should decode a polyline correctly" do
        expect(described_class.decode("krk{FdxdlO?e@")).to eq points
      end
    end
  end
end
