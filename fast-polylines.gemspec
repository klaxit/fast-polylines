# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "fast-polylines/version"

Gem::Specification.new do |s|
  s.name        = "fast-polylines"
  s.version     = FastPolylines::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Cyrille Courtière"]
  s.email       = ["cyrille@klaxit.com"]
  s.homepage    = "https://github.com/klaxit/fast-polylines"
  s.summary     = "Fast & easy Google polylines"
  s.license     = "MIT"

  s.files = `git ls-files -- lib/*`.split("\n")
  s.files += ["README.md"]
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = "lib"

  s.add_development_dependency("benchmark-ips")
  s.add_development_dependency("polylines", "~> 0.3")
  s.add_development_dependency("rspec", "~> 3.5")
end
