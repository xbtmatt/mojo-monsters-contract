module mojo_monsters::biomass {
    use std::signer;
    use std::vector;
    use std::string::{String};
    use mojo_monsters::object_refs;
    use mojo_monsters::type_discriminators;
    use mojo_monsters::enums;
    use mojo_monsters::element::None;
    use mojo_monsters::affinity::{Balanced, Solid, Swift};
    use mojo_monsters::access_control;
    use aptos_framework::object::{Self, Object};
    use aptos_token_objects::token::{Token};
    use aptos_framework::simple_map::{Self, SimpleMap};

    friend mojo_monsters::initialize;

    // lookup by: d[element][affinity] = biomass_address
    struct BiomassMetadata has key {
        address_map: SimpleMap<String, SimpleMap<String, address>>,
    }

    struct Biomass<phantom Element, phantom Affinity> has key { }

    const BIOMASS_MAX_SUPPLY: u128 = 100_000_000;
    const BIOMASS_INITIAL_SUPPLY: u128 = 10;

    public(friend) fun init(director: &signer) {
        access_control::assert_is_director(director);
        let element_names = enums::get_element_names();
        let empty_maps = vector::map_ref<String, SimpleMap<String, address>>(&element_names, |_e| {
            simple_map::new<String, address>()
        });
        move_to(
            director,
            BiomassMetadata {
                address_map: simple_map::new_from(element_names, empty_maps),
            }
        );
    }

    public(friend) fun create_base_fungible_token(director: &signer) {
        access_control::assert_is_director(director);
        let element_types = enums::get_element_names();
        let affinity_types = enums::get_affinity_names();
        vector::for_each(element_types, |element_type| {
            if (element_type == enums::name<None>()) {
                vector::for_each(affinity_types, |affinity_type| {
                    if (affinity_type == enums::name<Balanced>()) {

                    } else if (affinity_type == enums::name<Solid>()) {

                    } else if (affinity_type == enums::name<Swift>()) {

                    } else {

                    };
                });
            } else {
                // initial mint has 0 elements
                // TODO: Add the initial creation of these later.
            }
        });

    }

    // public fun get_biomass_metadata<Element, Affinity>(obj_addr: address): address acquires Biomass {
        // borrow_global<Biomass<Element, Affinity>>(obj_addr);
        // obj_addr
    // }


    public(friend) fun create<Element, Affinity>(
        for: &signer,
    ): Object<Biomass<Element, Affinity>> {
        type_discriminators::assert_is_element<Element>();
        type_discriminators::assert_is_affinity<Affinity>();

        let for_addr = signer::address_of(for);
        let constructor_ref = object::create_object(for_addr);
        let (obj_signer, obj_addr) = object_refs::create_refs<Token>(&constructor_ref);
        move_to(
            &obj_signer,
            Biomass<Element, Affinity> { }
        );
        object::address_to_object<Biomass<Element, Affinity>>(obj_addr)
    }

    // This solely deletes the Cauldron<Element> resource, not the underlying object or token.
    public(friend) fun destroy<Element, Affinity>(
        obj_addr: address
    ) acquires Biomass {
        let Biomass { } = move_from<Biomass<Element, Affinity>>(obj_addr);
    }
}
