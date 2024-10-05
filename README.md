# Fast Polylines

[![Gem](https://img.shields.io/gem/v/fast-polylines)](https://rubygems.org/gems/fast-polylines)
[![Continuous Integration Status](https://github.com/klaxit/fast-polylines/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/klaxit/fast-polylines/actions?query=workflow%3A%22Continuous+Integration%22)

Implementation of the [Google polyline algorithm][algorithm].

**BREAKING CHANGES:** The version 2 of FastPolylines includes breaking changes, see [Migrate from V1](#migrate-from-V1)

About **300x faster encoding and decoding** than [Joshua Clayton's gem][polylines].

`make benchmark` on a MacBook pro 13 - 2,3 GHz Intel Core i5:

```
——————————————————————————————— ENCODING ————————————————————————————————

Warming up --------------------------------------
           Polylines   310.000  i/100ms
     FastPolylinesV1     2.607k i/100ms
     FastPolylinesV2    59.833k i/100ms
Calculating -------------------------------------
           Polylines      2.957k (± 5.9%) i/s -     14.880k in   5.049867s
     FastPolylinesV1     25.644k (± 5.8%) i/s -    127.743k in   4.999954s
     FastPolylinesV2    682.981k (± 7.7%) i/s -      3.410M in   5.025952s

Comparison:
     FastPolylinesV2:   682980.7 i/s
     FastPolylinesV1:    25643.7 i/s - 26.63x  slower
           Polylines:     2957.1 i/s - 230.97x  slower


———————————————————————————————  DECODING ————————————————————————————————

Warming up --------------------------------------
           Polylines   127.000  i/100ms
     FastPolylinesV1     1.225k i/100ms
     FastPolylinesV2    40.667k i/100ms
Calculating -------------------------------------
           Polylines      1.289k (± 6.1%) i/s -      6.477k in   5.046552s
     FastPolylinesV1     15.445k (± 4.4%) i/s -     77.175k in   5.006896s
     FastPolylinesV2    468.413k (± 7.8%) i/s -      2.359M in   5.068936s

Comparison:
     FastPolylinesV2:   468412.8 i/s
     FastPolylinesV1:    15445.4 i/s - 30.33x  slower
           Polylines:     1288.8 i/s - 363.46x  slower
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
require "fast_polylines"

FastPolylines.encode([[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]])
# "_p~iF~ps|U_ulLnnqC_mqNvxq`@"

FastPolylines.decode("_p~iF~ps|U_ulLnnqC_mqNvxq`@")
# [[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]]
```

## Advanced usage

**Use a different precision**

Default precision is `5` decimals, to use a precision of `6`:

```ruby
FastPolylines.encode([[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]], 6)
# "_izlhA~rlgdF_{geC~ywl@_kwzCn`{nI"

FastPolylines.decode("_izlhA~rlgdF_{geC~ywl@_kwzCn`{nI", 6)
# [[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]]
```

The precision max is `13`.

## Migrate from V1

**TL;DR:**

```ruby
# before
require "fast-polylines"
FastPolylines::Encoder.encode([[1.2, 1.2], [2.4, 2.4]], 1e6)
# after
require "fast_polylines"
FastPolylines.encode([[1.2, 1.2], [2.4, 2.4]], 6)
```

**Detailled:**

The new version of `FastPolylines` doesn't support precision more than `1e13`,
you should not consider using it anyway since [it is way too precise][xkcd].

`Encoder` and `Decoder` modules are deprecated in favor of the single parent
module. Even though you can still use those, a deprecation warning will be
printed.

The precision is now an integer representing the number of decimals. It is
slightly smaller, and mostly this will avoid having any float value as
precision.

The file name to require is now snake_cased, you'll have to require
`fast_polylines`. The gem name stays the same however.

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
[xkcd]: https://xkcd.com/2170/
[ruby-c]: https://github.com/ruby/ruby/blob/master/doc/extension.rdoc
