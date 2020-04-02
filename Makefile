# This gives debug output in the C code and some debugger flags, useful for... Debugging.
# See ext/fast_polylines/extconf.rb
DEBUG = # 1
EXT_NAME = fast_polylines
RUBY_FLAG = -I lib:ext -r $(EXT_NAME)
ALL_TARGETS = $(wildcard ext/$(EXT_NAME)/*.c) $(wildcard ext/$(EXT_NAME)/*.h)

.PHONY: console
console: ext
	irb $(RUBY_FLAG)

.PHONY: test
test: ext
	bundle exec rspec

.PHONY: rubocop
rubocop:
	bundle exec rubocop

.PHONY: benchmark
benchmark: ext
	bundle exec ruby $(RUBY_FLAG) ./perf/benchmark.rb

ext/$(EXT_NAME)/Makefile: ext/$(EXT_NAME)/extconf.rb
	cd ext/$(EXT_NAME) && ruby extconf.rb --vendor

ext/$(EXT_NAME)/$(EXT_NAME).bundle: ext/$(EXT_NAME)/Makefile $(ALL_TARGETS)
	make -C ext/$(EXT_NAME)

.PHONY: ext
ext: ext/$(EXT_NAME)/$(EXT_NAME).bundle

.PHONY: clean
clean:
	cd ext/$(EXT_NAME) && make clean
	rm ext/$(EXT_NAME)/Makefile
