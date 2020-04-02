require "rubygems"
require "bundler/setup"

$LOAD_PATH.unshift File.join(__dir__, "..", "lib")
$LOAD_PATH.unshift File.join(__dir__, "..", "ext")

require "fast_polylines"

RSpec.configure do |config|
  # Additional config goes here
end
