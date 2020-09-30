#include <ruby.h>

// An encoded number can have at most _precision_ characters. However,
// it seems like we have a fuzzy behavior on low precisions. Hence a guard
// for those lower precisions.
#define MAX_ENCODED_CHUNKS(precision) (precision < 5 ? 5 : precision)

#define DEFAULT_PRECISION 5

// Already smaller than a sand grain. https://xkcd.com/2170/
// In fact, at 15 precision, we can be sure there will be precision loss
// in the C/Ruby value conversion. And 14 precision may be an edge case
// since we work with signed values.
#define MAX_PRECISION 13

// Uncomment this line to show debug logs.
// #define DEBUG 1

#ifdef DEBUG
#define dbg(...) printf(__VA_ARGS__)
#define rdbg(value) rb_funcall(Qnil, rb_intern("p"), 1, value)
#else
#define dbg(...)
#define rdbg(...)
#endif

typedef unsigned int uint;

static inline uint _get_precision(VALUE value) {
	int precision = NIL_P(value) ? DEFAULT_PRECISION : NUM2INT(value);
	if (precision > MAX_PRECISION) rb_raise(rb_eArgError, "precision too high (https://xkcd.com/2170/)");
	if (precision < 0) rb_raise(rb_eArgError, "negative precision doesn't make sense");
	return (uint)precision;
}

static inline VALUE
rb_FastPolylines__decode(int argc, VALUE *argv, VALUE self) {
	rb_check_arity(argc, 1, 2);
	Check_Type(argv[0], T_STRING);
	char* polyline = StringValueCStr(argv[0]);
	uint precision = _get_precision(argc > 1 ? argv[1] : Qnil);
	double precision_value = pow(10.0, precision);
	VALUE ary = rb_ary_new();
	// Helps keeping track of whether we are computing lat (0) or lng (1).
	uint8_t index = 0;
	size_t shift = 0;
	int64_t delta = 0;
	VALUE sub_ary[2];
	double latlng[2] = {0.0, 0.0};
	// Loops until end of string nul character is encountered.
	while (*polyline) {
		int64_t chunk = *polyline++;

		if (chunk < 63 || chunk > 126) {
			rb_raise(rb_eArgError, "invalid character '%c'", (char)chunk);
		}

		chunk -= 63;
		delta = delta | ((chunk & ~0x20) << shift);
		shift += 5;

		if (!(chunk & 0x20)) {
			delta = (delta & 1) ? ~(delta >> 1) : (delta >> 1);
			latlng[index] += delta;
			sub_ary[index] = rb_float_new((double) latlng[index] / precision_value);
			// When both coordinates are parsed, we can push those to the result ary.
			if (index) rb_ary_push(ary, rb_ary_new_from_values(2, sub_ary));
			// Reinitilize since we are done for current coordinate.
			index = 1 - index; delta = 0; shift = 0;
		}
	}
	return ary;
}

static inline uint8_t
_polyline_encode_number(char *chunks, int64_t number) {
	dbg("_polyline_encode_number(\"%s\", %lli)\n", chunks, number);
	number = number < 0 ? ~(number << 1) : (number << 1);
	uint8_t i = 0;
	while (number >= 0x20) {
		uint8_t chunk = number & 0x1f;
		chunks[i++] = (0x20 | chunk) + 63;
		number = number >> 5;
	}
	chunks[i++] = number + 63;
	dbg("%u encoded chunks\n", i);
	dbg("chunks: %s\n", chunks);
	dbg("/_polyline_encode_number\n");
	return i;
}

static inline VALUE
rb_FastPolylines__encode(int argc, VALUE *argv, VALUE self) {
	rb_check_arity(argc, 1, 2);
	Check_Type(argv[0], T_ARRAY);
	size_t len = RARRAY_LEN(argv[0]);
	uint64_t i;
	VALUE current_pair;
	int64_t prev_pair[2] = {0, 0};
	uint precision = _get_precision(argc > 1 ? argv[1] : Qnil);
	dbg("rb_FastPolylines__encode(..., %u)\n", precision);
	rdbg(argv[0]);
	double precision_value = pow(10.0, precision);
	// This is the maximum possible size the polyline may have. This
	// being **without** null character. To copy it later as a Ruby
	// string we'll have to use `rb_str_new` with the length.
	dbg("allocated size: %u * 2 * %lu = %lu\n",
	    MAX_ENCODED_CHUNKS(precision),
	    len,
	    MAX_ENCODED_CHUNKS(precision) * 2 * len);
	char *chunks = malloc(MAX_ENCODED_CHUNKS(precision) * 2 * len * sizeof(char));
	size_t chunks_index = 0;
	for (i = 0; i < len; i++) {
			current_pair = RARRAY_AREF(argv[0], i);
			uint8_t j;
			Check_Type(current_pair, T_ARRAY);
			if (RARRAY_LEN(current_pair) != 2) {
				free(chunks);
				rb_raise(rb_eArgError, "wrong number of coordinates");
			}
			for (j = 0; j < 2; j++) {
				VALUE current_value =	RARRAY_AREF(current_pair, j);
				switch (TYPE(current_value)) {
					case T_BIGNUM:
					case T_FLOAT:
					case T_FIXNUM:
					case T_RATIONAL:
						break;
					default:
						free(chunks);
						rb_raise(rb_eTypeError, "no implicit conversion to Float from %s", rb_obj_classname(current_value));
				};

				double parsed_value = NUM2DBL(current_value);
				if (-180.0 > parsed_value || parsed_value > 180.0) {
					free(chunks);
					rb_raise(rb_eArgError, "coordinates must be between -180.0 and 180.0");
				}
				int64_t rounded_value = round(parsed_value * precision_value);
				int64_t delta = rounded_value - prev_pair[j];
				prev_pair[j] = rounded_value;
				// We pass a pointer to the current chunk that need to be filled. Doing so
				// avoid having to copy the string every single iteration.
				chunks_index += _polyline_encode_number(chunks + chunks_index * sizeof(char), delta);
				dbg("%s\n", chunks);
			}
	}
	dbg("final chunks_index: %zu\n", chunks_index);
	VALUE polyline = rb_str_new(chunks, chunks_index);
	free(chunks);
	return polyline;
}

void Init_fast_polylines() {
	VALUE mFastPolylines = rb_define_module("FastPolylines");
	rb_define_module_function(mFastPolylines, "decode", rb_FastPolylines__decode, -1);
	rb_define_module_function(mFastPolylines, "encode", rb_FastPolylines__encode, -1);
}
