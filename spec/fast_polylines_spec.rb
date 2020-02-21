require "spec_helper"

describe FastPolylines do
  describe ".decode" do
    let(:points) { [[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]] }
    context "with default precision" do
      let(:polyline) { "_p~iF~ps|U_ulLnnqC_mqNvxq`@" }
      it "should decode a polyline correctly" do
        expect(described_class.decode(polyline)).to eq points
      end
    end
    context "with a 6 decimals precision" do
      let(:polyline) { "_izlhA~rlgdF_{geC~ywl@_kwzCn`{nI" }
      it "should decode a polyline correctly" do
        expect(described_class.decode(polyline, 6)).to eq points
      end
    end
    context "with a 15 decimals precision" do
      it "should raise" do
        expect { described_class.decode("_kiF_kiF", 15) }.to raise_error(ArgumentError, /too high/)
      end
    end
    context "with a negative precision" do
      it "should raise" do
        expect { described_class.decode("_kiF_kiF", -rand(1..10)) }.to raise_error(ArgumentError, /negative/)
      end
    end
    context "with wrong characters" do
      it "should raise" do
        chr = "~".next
        expect { described_class.decode(chr) }.to raise_error(ArgumentError, /'#{chr}'/)
      end
    end
    context "with points that were close together" do
      let(:points) { [[41.35222, -86.04563], [41.35222, -86.04544]] }
      it "should decode a polyline correctly" do
        expect(described_class.decode("krk{FdxdlO?e@")).to eq points
      end
    end
    context "with points that cause float overflow" do
      let(:polyline) { "ahdiHsmeMHPDN|A`FVt@" }
      let(:points) { [[48.85137, 2.32682], [48.85132, 2.32673], [48.85129, 2.32665], [48.85082, 2.32552], [48.8507, 2.32525]] }
      it "should respect precision" do
        expect(described_class.decode(polyline)).to eq points
      end
    end
  end

  describe ".encode" do
    let(:points)   { [[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]] }
    context "with default precision" do
      let(:polyline) { "_p~iF~ps|U_ulLnnqC_mqNvxq`@" }
      it "should encode points correctly" do
        expect(described_class.encode(points)).to eq polyline
      end
    end
    context "with a 6 decimals precision" do
      let(:polyline) { "_izlhA~rlgdF_{geC~ywl@_kwzCn`{nI" }
      it "should encode points correctly" do
        expect(described_class.encode(points, 6)).to eq polyline
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
    context "with points out of bounds" do
      it "should raise" do
        expect { described_class.encode([[180.1, 0.0]]) }.to raise_error ArgumentError
        expect { described_class.encode([[0, 180.1]]) }.to raise_error ArgumentError
        expect { described_class.encode([[-180.1, 0.0]]) }.to raise_error ArgumentError
        expect { described_class.encode([[0, -180.1]]) }.to raise_error ArgumentError
      end
    end
    context "with a 15 decimals precision" do
      it "should raise" do
        expect { described_class.encode([[1.2, 1.2]], 15) }.to raise_error(ArgumentError, /too high/)
      end
    end
    context "with a negative precision" do
      it "should raise" do
        expect { described_class.encode([[1.2, 1.2]], -rand(1..10)) }.to raise_error(ArgumentError, /negative/)
      end
    end
  end
end
