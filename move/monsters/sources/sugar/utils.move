module mojo_monsters::utils {
    use std::vector;
    use std::error;
    use std::string::{Self, String};

    /// Vector lengths do not match.
    const E_VECTOR_LENGTHS_DO_NOT_MATCH: u64 = 0;

    const DECIMALS: u8 = 0;
    const PROJECT_URI: vector<u8> = b"";

    public fun get_decimals(): u8 { DECIMALS }
    public fun get_project_uri(): String { string::utf8(PROJECT_URI) }

    public inline fun transpose<T: copy + drop + store>(v: vector<vector<T>>): vector<vector<T>> {
        let first_el = vector::borrow(&v, 0);
        let all_equal_length = vector::all(&v, |vv| {
            vector::length<T>(vv) == vector::length<T>(first_el)
        });
        assert!(all_equal_length, error::invalid_argument(E_VECTOR_LENGTHS_DO_NOT_MATCH));

        let new_outer = vector<vector<T>> [];
        vector::enumerate_ref(&v, |i, vv| {
            if (i == 0) {
                // initialize the new outer vector
                vector::for_each_ref(vv, |_vvv| {
                    vector::push_back(&mut new_outer, vector<T> []);
                });
            };
            vector::enumerate_ref(vv, |ii, vvv| {
                let transposed = vector::borrow_mut(&mut new_outer, ii);
                vector::push_back(transposed, *vvv);
            });
        });
        new_outer
    }

    #[test]
    fun test_transpose() {
        let vec1 = vector<u8> [ 0, 1, 2, 3, 4 ];
        let vec2 = vector<u8> [ 1, 1, 1, 1, 1 ];
        let vec3 = vector<u8> [ 2, 2, 2, 2, 2 ];
        let vecvec = vector<vector<u8>> [ vec1, vec2, vec3 ];
        let transposed = transpose(vecvec);

        assert!(transposed == vector<vector<u8>>[
            vector<u8> [ 0, 1, 2 ],
            vector<u8> [ 1, 1, 2 ],
            vector<u8> [ 2, 1, 2 ],
            vector<u8> [ 3, 1, 2 ],
            vector<u8> [ 4, 1, 2 ],
        ], 0);
    }
}
