PHONY: test

console:
	irb -I lib -r fast-polylines

test:
	bundle exec rspec spec

benchmark:
	bundle exec ruby ./perf/benchmark.rb
