# frozen_string_literal: true

require "fast_polylines/fast_polylines"

module FastPolylines::Encoder
  # @deprecated Use {FastPolylines.encode} instead.
  module_function def encode(points, precision = 1e5)
    warn "Deprecated use of `FastPolylines::Encoder.encode`, " \
         "use `FastPolylines.encode`."
    FastPolylines.encode(points, Math.log10(precision))
  end
end

module FastPolylines::Decoder
  # @deprecated Use {FastPolylines.decode} instead.
  module_function def decode(polyline, precision = 1e5)
    warn "Deprecated use of `FastPolylines::Decoder.decode`, " \
         "use `FastPolylines.decode`."
    FastPolylines.decode(polyline, Math.log10(precision))
  end
end
