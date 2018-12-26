module FastPolylines
  ##
  # Provide an interface to decode a Google polyline
  # to an array of lat / lng points
  class Decoder
    ##
    # Decode a polyline to a list of points
    #
    # @param [String] polyline to be decoded
    # @param [Float] precision of the polyline (default 1e5)
    # @return [Array<Array>] A list of lat / lng pairs
    def self.decode(polyline, precision = 1e5)
      coords = []
      acc = ""
      polyline.each_byte do |b|
        acc << b
        next unless b < 0x5f
        coords << acc
        acc = ""
      end
      lat = lng = 0
      coords.each_slice(2).map do |coords_pair|
        lat += decode_number(coords_pair[0])
        lng += decode_number(coords_pair[1])
        [lat / precision, lng / precision]
      end
    end

    ##
    # Decode a spaciotemporal polyline to a list of points
    #
    # @param [String] polyline to be decoded
    # @param [Float] precision of the polyline (default 1e5)
    # @return [Array<Array>] A list of lat / lng / timestamp triplets
    def self.decode_spaciotemporal(polyline, precision = 1e5)
      coords = []
      acc = ""
      polyline.each_byte do |b|
        acc << b
        next unless b < 0x5f
        coords << acc
        acc = ""
      end
      lat = lng = ts = 0
      coords.each_slice(3).map do |coords_pair|
        lat += decode_number(coords_pair[0])
        lng += decode_number(coords_pair[1])
        ts += decode_number(coords_pair[2])
        [lat / precision, lng / precision, ts]
      end
    end

    def self.decode_number(string)
      result = 1
      shift = 0
      string.each_byte do |b|
        b = b - 63 - 1
        result += b << shift
        shift += 5
      end
      (result & 1).nonzero? ? (~result >> 1) : (result >> 1)
    end
    private_class_method :decode_number
  end
end
