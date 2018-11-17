require "fast-polylines"
require "polylines"
require "benchmark"
require "benchmark/ips"

POLYLINE = "{leiHkmjM}z@vcE~JlKx@b~A~Jpy@vv@bhArLpVxFta@sCjEbL~c@rEn{@_HzXj" \
           "EdUg@rfCbHbSp\\fKpQzSg@|fCxTfvAzZduEyC|z@al@l~BcOnzBr@jUfuDfgFf" \
           "xAbzA~HxUfKcE_B}YbEyWti@_rAr`AhNte@x]dLyk@|Vyd@".freeze
POINTS = [
  [48.85726, 2.35238], [48.86685, 2.3209], [48.86493, 2.31891],
  [48.86464, 2.30369], [48.86272, 2.29432], [48.8538, 2.28262],
  [48.85162, 2.27885], [48.85037, 2.2733], [48.85111, 2.27228],
  [48.84901, 2.26636], [48.84795, 2.25668], [48.84939, 2.25254],
  [48.84837, 2.24899], [48.84857, 2.22729], [48.84711, 2.22407],
  [48.84238, 2.22211], [48.83941, 2.21877], [48.83961, 2.19702],
  [48.83612, 2.18306], [48.83166, 2.14879], [48.83243, 2.1392],
  [48.83964, 2.11881], [48.84222, 2.09905], [48.84196, 2.09547],
  [48.8128, 2.05831], [48.79852, 2.04373], [48.79692, 2.04008],
  [48.79496, 2.04106], [48.79544, 2.04537], [48.79446, 2.04934],
  [48.78763, 2.06262], [48.77713, 2.06017], [48.77094, 2.05524],
  [48.76883, 2.06241], [48.765, 2.06846]
].freeze

puts "\n** ENCODING **\n\n"

Benchmark.ips do |x|
  x.report("Polylines encode") { Polylines::Encoder.encode_points(POINTS) }
  x.report("FastPolylines encode") { FastPolylines::Encoder.encode(POINTS) }

  x.compare!
end

puts "\n** DECODING **\n\n"

Benchmark.ips do |x|
  x.report("Polylines decode") { Polylines::Decoder.decode_polyline(POLYLINE) }
  x.report("FastPolylines decode") { FastPolylines::Decoder.decode(POLYLINE) }

  x.compare!
end
