module mojo_monsters::stats {
    use std::error;
    use std::vector;
    use std::signer;
    use aptos_framework::simple_map::{Self, SimpleMap};
    use std::string::{String};
    use mojo_monsters::enums;
    use mojo_monsters::i64::{pos, zero, neg, add_i64, add_assert_positive, I64};
    use mojo_monsters::utils::{transpose};
    use mojo_monsters::mojo_errors;
    use mojo_monsters::type_discriminators;

    #[test_only] friend mojo_monsters::test_setup;


    /// Vector lengths do not match.
    const E_VECTOR_LENGTHS_DO_NOT_MATCH: u64 = 1;
    /// Not enough types to match the number of enums required.
    const E_INCORRECT_NUM_ENUMS: u64 = 2;

    struct AttributeModifiers has key {
        inner: SimpleMap<String, SimpleMap<String, I64>>,
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
            vector<I64> [ pos(20), zero(),  pos(20), zero(),  pos(20), neg(20), neg(20), zero(),  zero(), pos(20), pos(20), zero(), pos(20), pos(20) ],  // Ether
            vector<I64> [ zero(), zero(), zero(), zero(),  zero(),  zero(),  zero(),  zero(),  zero(), zero(),  zero(), zero(), zero(),  zero()  ],  // Balanced
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


    fun init_module(deployer: &signer) {
        assert!(signer::address_of(deployer) == @mojo_monsters, mojo_errors::not_authorized());

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
        assert!(type_discriminators::is_an_element<ElementOrAttribute>() || type_discriminators::is_an_affinity<ElementOrAttribute>(), mojo_errors::invalid_type());
        let _indirect_assertion = enums::attribute(attribute);
        let attribute_modifiers = borrow_global<AttributeModifiers>(@mojo_monsters);
        assert!(simple_map::contains_key(&attribute_modifiers.inner, &attribute), 0);
        let attribute_maps = simple_map::borrow(&attribute_modifiers.inner, &attribute);
        let modifiers = simple_map::borrow(attribute_maps, &enums::name<ElementOrAttribute>());
        *modifiers
    }


    public fun get_mojo_modifier<Element, Affinity>(attribute: String): I64 acquires AttributeModifiers {
        let element_modifier = get_modifier<Element>(attribute);
        let affinity_modifier = get_modifier<Affinity>(attribute);
        add_i64(element_modifier, affinity_modifier)
    }

    public fun get_starting_attribute<Element, Affinity>(base_attribute_value: u64, attribute: String): u64 acquires AttributeModifiers {
        let mojo_modifier = get_mojo_modifier<Element, Affinity>(attribute);
        add_assert_positive(pos(base_attribute_value), mojo_modifier)
    }

    #[test_only] use mojo_monsters::element;
    #[test_only] use mojo_monsters::affinity;
    #[test_only] use std::string;
    #[test_only] use mojo_monsters::i64::{equals};

    #[test_only]
    public(friend) fun init_module_for_test(deployer: &signer) {
        init_module(deployer);
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

}