module mojo_monsters::stats {
    use std::error;
    use std::vector;
    use std::signer;
    use aptos_framework::simple_map::{Self, SimpleMap};
    use std::string::{String};
    use mojo_monsters::enums;

    #[test_only] friend mojo_monsters::test_setup;

    const ELEMENT_NAMES: vector<vector<u8>> = vector<vector<u8>> [ b"FIRE", b"EARTH", b"WATER", b"AIR", b"CRYSTAL", b"ELECTRICITY", b"ETHER" ];
    const AFFINITY_NAMES: vector<vector<u8>> = vector<vector<u8>>[ b"SOLID", b"SWIFT", b"HARMONIC", b"PSYCHE", b"ADAPTIVE", b"DISRUPTIVE" ];
    const MULTIPLIER_KEY: vector<u8> = b"MULTIPLIERS";

    /// You are not authorized to perform this action.
    const E_NOT_AUTHORIZED: u64 = 0;
    /// Vector lengths do not match.
    const E_VECTOR_LENGTHS_DO_NOT_MATCH: u64 = 1;
    /// Not enough types to match the number of enums required.
    const E_INCORRECT_NUM_ENUMS: u64 = 2;
    /// You've passed in an invalid type.
    const E_INVALID_TYPE: u64 = 2;
    /// You've passed in invalid arguments that summed to a negative number.
    const E_ARITHMETIC_ERROR: u64 = 3;

    struct AttributeModifiers has key {
        inner: SimpleMap<String, SimpleMap<String, I64>>,
    }

    struct I64 has copy, drop, store {
        neg: bool,
        value: u64,
    }

    inline fun add_I64(a: I64, b: I64): I64 {
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

    inline fun add_assert_positive(a: I64, b: I64): u64 {
        let result = add_I64(a, b);
        assert!(!result.neg, error::invalid_argument(E_ARITHMETIC_ERROR));
        result.value
    }

    // purely for readability/maintainability's sake
    // returns (key, SimpleMap<String, I64>)
    inline fun create_game_stat(key: String, inner_keys: vector<String>, stat: vector<I64>): (String, SimpleMap<String, I64>) {
        let inner_maps = simple_map::new_from(inner_keys, stat);
        (key, simple_map::new_from(inner_keys, stat))
    }

    inline fun pos(i: u64): I64 {
        I64 { neg: false, value: i }
    }

    inline fun neg(i: u64): I64 {
        I64 { neg: true, value: i }
    }

    inline fun zero(): I64 {
        I64 { neg: false, value: 0 }
    }

    inline fun abs(i: I64): I64 {
        I64 { neg: false, value: i.value }
    }

    inline fun equals(a: I64, b: I64): bool {
        if (a.value == 0 && b.value == 0) {
            true
        } else {
            a.neg == b.neg && a.value == b.value
        }
    }

    inline fun spreadsheet(): vector<vector<I64>> {
        // Element,Energy Capacity,Energy Recharge Rate,Energy Efficiency,Hunger Capacity,Hunger Resistance,Happiness Capacity,Joy Response,joy ability,Immunity Threshold,Immunity Persistence,Inherent Intelligence,Learning Potential
        let spreadsheet_data = vector<vector<I64>> [
            vector<I64> [ pos(20), pos(20), neg(10), zero(),  neg(10), zero(),  zero(),  zero(),  zero(), zero(),  zero(),  zero(), zero(),  zero()  ],  // Fire
            vector<I64> [ zero(),  zero(),  pos(10), zero(),  zero(),  zero(),  zero(),  zero(),  zero(), zero(),  pos(10), zero(), zero(),  neg(10) ],  // Earth
            vector<I64> [ zero(),  pos(10), zero(),  neg(10), pos(10), zero(),  zero(),  zero(),  zero(), zero(),  zero(),  zero(), zero(),  zero()  ],  // Water
            vector<I64> [ neg(10), zero(),  pos(10), zero(),  neg(10), zero(),  pos(20), zero(),  zero(), zero(),  zero(),  zero(), zero(),  zero()  ],  // Air
            vector<I64> [ zero(),  zero(),  pos(10), zero(),  zero(),  zero(),  zero(),  zero(),  zero(), pos(10), pos(10), zero(), pos(10), zero()  ],  // Crystal
            vector<I64> [ pos(30), pos(30), pos(30), zero(),  neg(20), pos(20), pos(20), zero(),  zero(), zero(),  zero(),  zero(), zero(),  zero()  ],  // Electricity
            vector<I64> [ pos(20), zero(),  pos(20), zero(),  pos(20), neg(20), neg(20), zero(),  zero(), pos(20), pos(20), zero(), pos(20), pos(20) ],  // Etherther
            vector<I64> [ pos(20), neg(10), neg(10), zero(),  zero(),  zero(),  zero(),  zero(),  zero(), zero(),  pos(10), zero(), zero(),  zero()  ],  // Solid
            vector<I64> [ zero(),  pos(20), zero(),  zero(),  neg(20), zero(),  pos(10), zero(),  zero(), zero(),  neg(10), zero(), zero(),  zero()  ],  // Swift
            vector<I64> [ neg(10), zero(),  pos(10), zero(),  pos(10), zero(),  pos(20), pos(20), zero(), zero(),  zero(),  zero(), zero(),  zero()  ],  // Harmonic
            vector<I64> [ zero(),  zero(),  zero(),  zero(),  zero(),  pos(10), neg(10), zero(),  zero(), neg(10), neg(10), zero(), pos(20), pos(20) ],  // Psyche
            vector<I64> [ zero(),  zero(),  zero(),  zero(),  pos(10), zero(),  zero(),  zero(),  zero(), pos(20), pos(20), zero(), pos(10), zero()  ],  // Adaptive
            vector<I64> [ pos(20), pos(20), neg(20), zero(),  zero(),  pos(20), neg(10), neg(10), zero(), zero(),  zero(),  zero(), zero(),  zero(), ],  // Disruptive
        ];

        let first_el = vector::borrow(&spreadsheet_data, 0);
        let all_equal_length = vector::all(&spreadsheet_data, |v| {
            vector::length<I64>(v) == vector::length<I64>(first_el)
        });
        assert!(all_equal_length, error::invalid_argument(E_VECTOR_LENGTHS_DO_NOT_MATCH));

        let outer_spreadsheet_vector_length = vector::length(&spreadsheet_data);
        let num_element_names = vector::length(&enums::get_element_names());
        let num_affinity_names = vector::length(&enums::get_affinity_names());
        assert!(outer_spreadsheet_vector_length == (num_element_names + num_affinity_names), error::invalid_argument(E_INCORRECT_NUM_ENUMS));

        transpose(spreadsheet_data)
    }

    inline fun transpose<T: copy + drop + store>(v: vector<vector<T>>): vector<vector<T>> {
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

    fun init_module(deployer: &signer) {
        assert!(signer::address_of(deployer) == @mojo_monsters, error::permission_denied(E_NOT_AUTHORIZED));

        let inner_keys = vector<String> [];
        vector::append(&mut inner_keys, enums::get_element_names());
        vector::append(&mut inner_keys, enums::get_affinity_names());

        let spreadsheet_data = spreadsheet();
        // index 1 == Fire: Energy Capacity, Energy Recharge Rate, ..., Learning Potential
        // index 2 == Earth: Energy Capacity, Energy Recharge Rate, ..., Learning Potential
        // etc...
        let modifier_map = simple_map::new<String, SimpleMap<String, I64>>();
        vector::enumerate_ref(&enums::get_attribute_names(), |i, attribute| {
            let inner_map = simple_map::new<String, I64>();
            vector::enumerate_ref(&inner_keys, |ii, inner_key| {
                let column = vector::borrow(&spreadsheet_data, i);
                simple_map::add(&mut inner_map, *inner_key, *vector::borrow(column, ii));
            });
            simple_map::add(&mut modifier_map, *attribute, inner_map);
        });
        move_to(
            deployer,
            AttributeModifiers {
                inner: modifier_map,
            }
        );
    }

    fun get_modifier<ElementOrAttribute>(attribute: String): I64 acquires AttributeModifiers {
        assert!(enums::is_element_type<ElementOrAttribute>() || enums::is_affinity_type<ElementOrAttribute>(), error::invalid_argument(E_INVALID_TYPE));
        let _indirect_assertion = enums::attribute(attribute);
        let attribute_modifiers = borrow_global<AttributeModifiers>(@mojo_monsters);
        assert!(simple_map::contains_key(&attribute_modifiers.inner, &attribute), 0);
        let attribute_maps = simple_map::borrow(&attribute_modifiers.inner, &attribute);
        let modifiers = simple_map::borrow(attribute_maps, &enums::name<ElementOrAttribute>());
        *modifiers
    }


    public fun get_mojo_modifier<Element, Affinity>(attribute: String): I64 acquires AttributeModifiers {
        assert!(enums::is_element_type<Element>() || enums::is_affinity_type<Affinity>(), error::invalid_argument(E_INVALID_TYPE));
        let element_modifier = get_modifier<Element>(attribute);
        let affinity_modifier = get_modifier<Affinity>(attribute);
        add_I64(element_modifier, affinity_modifier)
    }

    public fun get_starting_attribute<Element, Affinity>(base_attribute_value: u64, attribute: String): u64 acquires AttributeModifiers {
        let mojo_modifier = get_mojo_modifier<Element, Affinity>(attribute);
        add_assert_positive(pos(base_attribute_value), mojo_modifier)
    }

    #[test_only] use mojo_monsters::element;
    #[test_only] use mojo_monsters::affinity;
    #[test_only] use std::string;

    #[test_only]
    public(friend) fun init_module_for_test(deployer: &signer) {
        init_module(deployer);
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

    #[test(deployer=@mojo_monsters)]
    fun test_modifiers(
        deployer: &signer,
    ) acquires AttributeModifiers {
        init_module_for_test(deployer);
        // singular modifiers
        assert!(get_modifier<element::Fire>(string::utf8(b"MAX_ENERGY")) == pos(20), 0);
        assert!(get_modifier<element::Air>(string::utf8(b"MAX_ENERGY")) == neg(10), 0);
        assert!(get_modifier<affinity::Psyche>(string::utf8(b"IMMUNITY_THRESHOLD")) == neg(10), 0);
        assert!(get_modifier<affinity::Adaptive>(string::utf8(b"IMMUNITY_THRESHOLD")) == pos(20), 0);
        // mojo modifiers
        assert!(equals(get_mojo_modifier<element::Fire, affinity::Solid>(string::utf8(b"MAX_ENERGY")), pos(40)), 0);
        assert!(equals(get_mojo_modifier<element::Ether, affinity::Disruptive>(string::utf8(b"ENERGY_EFFICIENCY")), zero()), 0);
    }

    // #[test_only] use std::string::{Self};

    #[test_only]
    fun test_stats_name_indexes_correct() {
        assert!(vector::map(ELEMENT_NAMES, |e| { string::utf8(e) }) == enums::get_element_names(), 0);
        assert!(vector::map(AFFINITY_NAMES, |e| { string::utf8(e) }) == enums::get_element_names(), 0);
    }

    #[test]
    fun test_negative_numbers() {
        assert!(add_I64(neg(10), neg(10)) == neg(20), 0);
        assert!(add_I64(pos(10), pos(10)) == pos(20), 0);
        assert!(add_I64(pos(10), pos(20)) == pos(30), 0);
        assert!(add_I64(neg(10), neg(20)) == neg(30), 0);
        assert!(add_I64(neg(20), neg(10)) == neg(30), 0);
        assert!(add_I64(neg(20), pos(10)) == neg(10), 0);
        assert!(add_I64(pos(20), neg(10)) == pos(10), 0);
        assert!(equals(add_I64(neg(10), pos(20)), pos(10)), 0);
        assert!(equals(pos(0), zero()), 0);
        assert!(equals(neg(0), zero()), 0);
    }


}