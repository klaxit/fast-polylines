# Fast Polylines

[![Gem Version](https://badge.fury.io/rb/fast-polylines.svg)](https://badge.fury.io/rb/fast-polylines)
[![Build Status](https://travis-ci.org/klaxit/fast-polylines.svg?branch=master)](https://travis-ci.org/klaxit/fast-polylines)

Implementation of the [Google polyline algorithm][algorithm].

**BREAKING CHANGES:** The version 2.0.0 of FastPolylines includes breaking changes, see [Migrate from 1.0.0](#migrate-from-1.0.0)


About **300x faster encoding and decoding**  than [Joshua Clayton's gem][polylines].

`make benchmark` on a MacBook pro 13 - 2,3 GHz Intel Core i5:

```
——————————————————————————————— ENCODING ————————————————————————————————

Warming up --------------------------------------
           Polylines   277.000  i/100ms
     FastPolylinesV1     2.050k i/100ms
     FastPolylinesV2    73.822k i/100ms
Calculating -------------------------------------
           Polylines      3.254k (± 1.8%) i/s -     16.343k in   5.023767s
     FastPolylinesV1     25.715k (± 3.7%) i/s -    129.150k in   5.029675s
     FastPolylinesV2    933.751k (± 4.3%) i/s -      4.725M in   5.072446s

Comparison:
     FastPolylinesV2:   933750.7 i/s
     FastPolylinesV1:    25715.1 i/s - 36.31x  slower
           Polylines:     3254.3 i/s - 286.93x  slower


———————————————————————————————  DECODING ————————————————————————————————

Warming up --------------------------------------
           Polylines   140.000  i/100ms
     FastPolylinesV1     1.602k i/100ms
     FastPolylinesV2    36.432k i/100ms
Calculating -------------------------------------
           Polylines      1.401k (± 2.2%) i/s -      7.000k in   5.000321s
     FastPolylinesV1     16.465k (± 3.7%) i/s -     83.304k in   5.067786s
     FastPolylinesV2    396.100k (± 5.2%) i/s -      2.004M in   5.074500s

Comparison:
     FastPolylinesV2:   396100.0 i/s
     FastPolylinesV1:    16464.6 i/s - 24.06x  slower
           Polylines:     1400.6 i/s - 282.81x  slower
```

## Install

```bash
gem install fast-polylines
```

or in your `Gemfile`:
```ruby
gem "fast-polylines", "~> 2.0.0"
```

## Usage

```ruby
require "fast-polylines"

FastPolylines.encode([[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]])
# "_p~iF~ps|U_ulLnnqC_mqNvxq`@"

FastPolylines.decode("_p~iF~ps|U_ulLnnqC_mqNvxq`@")
# [[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]]
```

## Advanced usage

**Use a different precision**

Default precision is `5` decimals, to use a precision of `6` decimals:
```ruby
FastPolylines.encode([[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]], 6)
# "_izlhA~rlgdF_{geC~ywl@_kwzCn`{nI"

FastPolylines.decode("_izlhA~rlgdF_{geC~ywl@_kwzCn`{nI", 6)
# [[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]]
```
The precision max is `13`.

## Migrate from 1.0.0

**TL;DR:**

```ruby
# before
FastPolylines::Encoder.encode([[1.2, 1.2], [2.4, 2.4]], 1e6)
# after
FastPolylines.encode([[1.2, 1.2], [2.4, 2.4]], 6)
```

The new version of `FastPolylines` doesn't support precision more than `1e13`,
you should not consider using it anyway since [it is way too precise][xkcd].

`Encoder` and `Decoder` modules are deprecated in favor of the single parent
module. Even though you can still use those, a deprecation warning will be
printed.

The precision is now an integer representing the number of decimals. It is
slightly smaller, and mostly this will avoid having any float value as
precision.

## Run the Benchmark

You can run the benchmark with `make benchmark`.

## Contributing

```bash
git clone git@github.com:klaxit/fast-polylines
cd fast-polylines
bundle install
# Implement a feature, resolve a bug...
make rubocop
make test
git commit "My new feature!"
# Make a PR
```

There is a `make console` command as well to open a ruby console with the
current version loaded.

[And here's a good starting point for Ruby C extensions knowledge.][ruby-c]

## License

Please see LICENSE


[algorithm]: https://code.google.com/apis/maps/documentation/utilities/polylinealgorithm.html
[polylines]: https://github.com/joshuaclayton/polylines
[xkcd]:      https://xkcd.com/2170/
[ruby-c]:    https://github.com/ruby/ruby/blob/master/doc/extension.rdoc
