require "rubygems"
require "bundler/setup"

require "fast-polylines"

require "rspec-benchmark"
require "polylines"

RSpec.configure do |config|
  include RSpec::Benchmark::Matchers
end
