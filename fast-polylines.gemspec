# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)
require "fast_polylines/version"

Gem::Specification.new do |s|
  s.name        = "fast-polylines"
  s.version     = FastPolylines::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Cyrille Courtière", "Ulysse Buonomo"]
  s.email       = ["dev@klaxit.com"]
  s.homepage    = "https://github.com/klaxit/fast-polylines"
  s.summary     = "Fast & easy Google polylines"
  s.license     = "MIT"

  s.files = `git ls-files -- {lib,ext}/*`.split("\n")
  s.files += ["README.md"]
  s.extensions = ["ext/fast_polylines/extconf.rb"]
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = "lib"

  s.add_development_dependency("benchmark-ips", "~> 2.7")
  s.add_development_dependency("polylines", "~> 0.3")
  s.add_development_dependency("rspec", "~> 3.5")
end
