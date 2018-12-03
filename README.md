# Fast Polylines

[![Gem Version](https://badge.fury.io/rb/fast-polylines.svg)](https://badge.fury.io/rb/fast-polylines)
[![CircleCI](https://circleci.com/gh/klaxit/fast-polylines.svg?style=shield&circle-token=:circle-token)](https://circleci.com/gh/klaxit/fast-polylines)

Implementation of the Google polyline algorithm :
http://code.google.com/apis/maps/documentation/utilities/polylinealgorithm.html

Greatly inspired by Joshua Clayton gem : https://github.com/joshuaclayton/polylines

But an about **8x faster encoding** and **10x faster decoding** implementation (`make benchmark` on a MacBook pro 13 - 2,3 GHz Intel Core i5).

```
** ENCODING **

Warming up --------------------------------------
    Polylines encode   282.000  i/100ms
FastPolylines encode     2.339k i/100ms
Calculating -------------------------------------
    Polylines encode      3.024k (± 7.4%) i/s -     15.228k in   5.068950s
FastPolylines encode     24.562k (± 6.7%) i/s -    123.967k in   5.074793s

Comparison:
FastPolylines encode:    24561.8 i/s
    Polylines encode:     3023.6 i/s - 8.12x  slower


** DECODING **

Warming up --------------------------------------
    Polylines decode   125.000  i/100ms
FastPolylines decode     1.341k i/100ms
Calculating -------------------------------------
    Polylines decode      1.284k (± 9.7%) i/s -      6.375k in   5.023536s
FastPolylines decode     13.278k (±20.5%) i/s -     61.686k in   5.003858s

Comparison:
FastPolylines decode:    13278.0 i/s
    Polylines decode:     1284.3 i/s - 10.34x  slower
```

## Install

```
gem install fast-polylines
```

or in Bundler:
```
gem "fast-polylines"
```

## Usage

```
require 'fast-polylines'

FastPolylines::Encoder.encode([[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]])
# "_p~iF~ps|U_ulLnnqC_mqNvxq`@"

FastPolylines::Decoder.decode("_p~iF~ps|U_ulLnnqC_mqNvxq`@")
# [[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]]
```

## Advanced usage

*  With a different precision (default precision of `1e5`) :

```
FastPolylines::Encoder.encode([[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]], 1e6)
# "_izlhA~rlgdF_{geC~ywl@_kwzCn`{nI"

FastPolylines::Decoder.decode("_izlhA~rlgdF_{geC~ywl@_kwzCn`{nI", 1e6)
# [[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]]
```

## Run the Benchmark

You can run the benchmark with `make benchmark`.

## License

Please see LICENSE
