module FastPolylines
  ##
  # Provides an interface to encode an array of lat / lng points
  # to a Google polyline
  #
  class Encoder
    ##
    # Encode a list of points into a polyline string
    #
    # @param [Array<Array>] points as lat/lng pairs
    # @param [Float] precision of the encoding (default 1e5)
    # @return [String] the encoded polyline
    def self.encode(points, precision = 1e5)
      result = ""
      last_lat = last_lng = 0
      points.each do |point|
        lat = (point[0] * precision).round
        lng = (point[1] * precision).round
        d_lat = lat - last_lat
        d_lng = lng - last_lng
        chunks_lat = encode_number(d_lat)
        chunks_lng = encode_number(d_lng)
        result << chunks_lat << chunks_lng
        last_lat = lat
        last_lng = lng
      end
      result
    end

    ##
    # Encode a list of spaciotemporal points into a polyline string
    #
    # @param [Array<Array>] points as lat/lng/timestamp triplets
    # @param [Float] precision of the encoding for lat and lng (default 1e5)
    # @return [String] the encoded polyline
    def self.encode_spaciotemporal(points, precision = 1e5)
      result = ""
      last_lat = last_lng = last_ts = 0
      points.each do |point|
        lat = (point[0] * precision).round
        lng = (point[1] * precision).round
        ts = point[2]
        d_lat = lat - last_lat
        d_lng = lng - last_lng
        d_ts = ts - last_ts
        chunks_lat = encode_number(d_lat)
        chunks_lng = encode_number(d_lng)
        chunks_ts = encode_number(d_ts)
        result << chunks_lat << chunks_lng << chunks_ts
        last_lat = lat
        last_lng = lng
        last_ts = ts
      end
      result
    end

    def self.encode_number(num)
      sgn_num = num << 1
      sgn_num = ~sgn_num if num < 0
      encode_unsigned_number(sgn_num)
    end

    def self.encode_unsigned_number(num)
      encoded = ""
      while num >= 0x20
        encoded << (0x20 | (num & 0x1f)) + 63
        num = num >> 5
      end
      encoded << num + 63
    end
    private_class_method :encode_number
    private_class_method :encode_unsigned_number
  end
end
