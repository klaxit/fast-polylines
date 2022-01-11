# Begin OS detection
ifeq ($(OS),Windows_NT) # is Windows_NT on XP, 2000, 7, Vista, 10...
    OPERATING_SYSTEM := Windows
    PATH_SEPARATOR := ;
else
    OPERATING_SYSTEM := $(shell uname)  # same as "uname -s"
	PATH_SEPARATOR := :
endif

# This gives debug output in the C code and some debugger flags, useful for... Debugging.
# See ext/fast_polylines/extconf.rb
DEBUG = # 1
EXT_NAME = fast_polylines
RUBY_FLAG = -I lib$(PATH_SEPARATOR)ext -r $(EXT_NAME)
ALL_TARGETS = $(wildcard ext/$(EXT_NAME)/*.c) $(wildcard ext/$(EXT_NAME)/*.h)

##@ Utility

FMT_TITLE='\\033[7\;1m'
FMT_PRIMARY='\\033[36m'
FMT_END='\\033[0m'
.PHONY: help
help: ## Shows this help menu.
	@printf -- "                               FAST-POLYLINES\n"
	@printf -- "---------------------------------------------------------------------------\n"
	@awk ' \
			BEGIN {FS = ":.*##"; printf "Usage: make ${FMT_PRIMARY}<target>${FMT_END}\n"} \
	    	/^[a-zA-Z0-9_-]+:.*?##/ { printf "  $(FMT_PRIMARY)%-30s$(FMT_END) %s\n", $$1, $$2 } \
			/^##@/ { printf "\n$(FMT_TITLE) %s $(FMT_END)\n", substr($$0, 5) } \
		' $(MAKEFILE_LIST)

.PHONY: console
console: ext ## Runs an irb console with fast-polylines
	irb $(RUBY_FLAG)

.PHONY: test
test: ext ## Runs tests
	bundle exec rspec

.PHONY: rubocop
rubocop: ## Checks ruby syntax
	bundle exec rubocop

.PHONY: benchmark
benchmark: ext ## Run the benchmark
	bundle exec ruby $(RUBY_FLAG) ./perf/benchmark.rb

.PHONY: publish
publish: test ## Publish to rubygems
	gem build
	gem push fast-polylines-*.gem

ext/$(EXT_NAME)/Makefile: ext/$(EXT_NAME)/extconf.rb
	cd ext/$(EXT_NAME) && ruby extconf.rb --vendor

ext/$(EXT_NAME)/$(EXT_NAME).bundle: ext/$(EXT_NAME)/Makefile $(ALL_TARGETS)
	make -C ext/$(EXT_NAME)

##@ C extension

.PHONY: ext
ext: ext/$(EXT_NAME)/$(EXT_NAME).bundle ## Compiles the C extension

.PHONY: clean
clean: ## Cleans compiled stuff
	cd ext/$(EXT_NAME) && make clean
	rm ext/$(EXT_NAME)/Makefile
	rm fast-polylines-*.gem
