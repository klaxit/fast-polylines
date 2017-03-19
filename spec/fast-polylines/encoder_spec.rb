require "spec_helper"

describe FastPolylines::Encoder do
  describe ".encode" do
    let(:points)   { [[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]] }
    context "with default precision" do
      let(:polyline) { "_p~iF~ps|U_ulLnnqC_mqNvxq`@" }
      it "should encode points correctly" do
        expect(described_class.encode(points)).to eq polyline
      end
      it "should perform at least 5x faster than the Polylines gem" do
        expect {
          described_class.encode(points)
        }.to perform_faster_than {
          Polylines::Encoder.encode_points(points)
        }.at_least(5).times
      end
    end
    context "with 1e6 precision" do
      let(:polyline) { "_izlhA~rlgdF_{geC~ywl@_kwzCn`{nI" }
      it "should encode points correctly" do
        expect(described_class.encode(points, 1e6)).to eq polyline
      end
    end
    context "with points that were close together" do
      let(:points) { [[41.35222, -86.04563], [41.35222, -86.04544]] }
      it "should encode points correctly" do
        expect(described_class.encode(points)).to eq "krk{FdxdlO?e@"
      end
    end
    context "with possible rounding ambiguity" do
      let(:points) { [[39.13594499,-94.4243478], [39.13558757,-94.4243471]] }
      it "should encode points as Google API do" do
        expect(described_class.encode(points)).to eq "svzmFdgi_QdA?"
      end
    end
  end
end
