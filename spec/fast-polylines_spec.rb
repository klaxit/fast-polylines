require "fast-polylines"

describe FastPolylines do
  let(:points) { [[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]] }
  let(:polyline) { "_p~iF~ps|U_ulLnnqC_mqNvxq`@" }
  it "should work with kebab-case requirement" do
    expect(FastPolylines.encode(points)).to eq polyline
    expect(FastPolylines.decode(polyline)).to eq points
  end
end
