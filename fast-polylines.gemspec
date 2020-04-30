# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)
require "fast_polylines/version"

Gem::Specification.new do |spec|
  spec.name        = "fast-polylines"
  spec.version     = FastPolylines::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ["Cyrille Courtière", "Ulysse Buonomo"]
  spec.email       = ["dev@klaxit.com"]
  spec.homepage    = "https://github.com/klaxit/fast-polylines"
  spec.summary     = "Fast & easy Google polylines"
  spec.license     = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.6")

  spec.files = Dir["{lib,ext}/**/*.{rb,c}"] + %w(README.md CHANGELOG.md)
  spec.extensions = ["ext/fast_polylines/extconf.rb"]
  spec.test_files =Dir["spec/**/*"] + %w(.rspec)
  spec.require_paths = "lib"

  spec.add_development_dependency("benchmark-ips", "~> 2.7")
  spec.add_development_dependency("polylines", "~> 0.3")
  spec.add_development_dependency("rspec", "~> 3.5")
end
