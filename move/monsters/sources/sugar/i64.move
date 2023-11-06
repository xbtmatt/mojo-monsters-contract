module mojo_monsters::i64 {
    use std::error;

    struct I64 has copy, drop, store {
        neg: bool,
        value: u64,
    }

    /// Vector lengths do not match.
    const E_VECTOR_LENGTHS_DO_NOT_MATCH: u64 = 0;
    /// You've passed in invalid arguments that summed to a negative number.
    const E_ARITHMETIC_ERROR: u64 = 1;

    public fun new (neg: bool, value: u64): I64 {
        I64 { neg: neg, value: value }
    }
    

    public fun add_i64(a: I64, b: I64): I64 {
        if (a.neg == b.neg) {
            I64 { neg: a.neg, value: a.value + b.value }
        } else {
            if (a.value > b.value) {
                I64 { neg: a.neg, value: a.value - b.value }
            } else {
                I64 { neg: b.neg, value: b.value - a.value }
            }
        }
    }

    public fun add_assert_positive(a: I64, b: I64): u64 {
        let result = add_i64(a, b);
        assert!(!result.neg, error::invalid_argument(E_ARITHMETIC_ERROR));
        result.value
    }

    public fun pos(i: u64): I64 {
        I64 { neg: false, value: i }
    }

    public fun neg(i: u64): I64 {
        I64 { neg: true, value: i }
    }

    public fun zero(): I64 {
        I64 { neg: false, value: 0 }
    }

    public fun abs(i: I64): I64 {
        I64 { neg: false, value: i.value }
    }

    public fun equals(a: I64, b: I64): bool {
        if (a.value == 0 && b.value == 0) {
            true
        } else {
            a.neg == b.neg && a.value == b.value
        }
    }

    #[test]
    fun test_negative_numbers() {
        assert!(add_i64(neg(10), neg(10)) == neg(20), 0);
        assert!(add_i64(pos(10), pos(10)) == pos(20), 0);
        assert!(add_i64(pos(10), pos(20)) == pos(30), 0);
        assert!(add_i64(neg(10), neg(20)) == neg(30), 0);
        assert!(add_i64(neg(20), neg(10)) == neg(30), 0);
        assert!(add_i64(neg(20), pos(10)) == neg(10), 0);
        assert!(add_i64(pos(20), neg(10)) == pos(10), 0);
        assert!(equals(add_i64(neg(10), pos(20)), pos(10)), 0);
        assert!(equals(pos(0), zero()), 0);
        assert!(equals(neg(0), zero()), 0);
    }
}
