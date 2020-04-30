require "rubygems"
require "bundler/setup"

$LOAD_PATH.unshift File.join(__dir__, "..", "lib")
$LOAD_PATH.unshift File.join(__dir__, "..", "ext")

RSpec.configure do |config|
  # Additional config goes here
end
