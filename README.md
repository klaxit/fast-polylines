# Fast Polylines

Implementation of the Google polyline algorithm :
http://code.google.com/apis/maps/documentation/utilities/polylinealgorithm.html

Inspired by Joshua Clayton gem : https://github.com/joshuaclayton/polylines

But **at least a 5x faster implementation**.

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

## License

Please see LICENSE
