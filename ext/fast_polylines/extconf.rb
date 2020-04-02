# frozen_string_literal: true

require "mkmf"

if ENV["DEBUG"]
  warn "DEBUG MODE."
  $CFLAGS << " " << %w(
    -Wall
    -ggdb
    -DDEBUG
    -pedantic
  ) * " "
end
create_makefile "fast_polylines/fast_polylines"
