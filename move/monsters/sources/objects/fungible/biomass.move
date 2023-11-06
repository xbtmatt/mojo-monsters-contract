module mojo_monsters::biomass {
    use std::signer;
    use std::vector;
    use std::string::{Self, String};
    use mojo_monsters::object_refs;
    use mojo_monsters::type_discriminators;
    use mojo_monsters::enums;
    use mojo_monsters::utils;
    use mojo_monsters::element::None;
    use mojo_monsters::affinity::{Balanced, Solid, Swift};
    use mojo_monsters::access_control;
    use mojo_monsters::mojo_errors;
    use mojo_monsters::fungible_token_manager;
    use aptos_framework::fungible_asset::{Metadata};
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

    const BALANCED_BIOMASS_NAME: vector<u8> = b"lil balanced";
    const BALANCED_BIOMASS_IMAGE: vector<u8> = b"https://dapps.nyc3.cdn.digitaloceanspaces.com/monsters/sample-biomasses/BALANCED_BIOMASS.png";
    const SOLID_BIOMASS_NAME: vector<u8> = b"mr solid";
    const SOLID_BIOMASS_IMAGE: vector<u8> = b"https://dapps.nyc3.cdn.digitaloceanspaces.com/monsters/sample-biomasses/SOLID_BIOMASS.png";
    const SWIFT_BIOMASS_NAME: vector<u8> = b"sir swift";
    const SWIFT_BIOMASS_IMAGE: vector<u8> = b"https://dapps.nyc3.cdn.digitaloceanspaces.com/monsters/sample-biomasses/SWIFT_BIOMASS.png";

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

    #[view]
    public fun get_biomass_addr<Element, Affinity>(): address acquires BiomassMetadata {
        let element_name = enums::name<Element>();
        let affinity_name = enums::name<Affinity>();
        let biomass_metadata = borrow_global<BiomassMetadata>(@mojo_monsters);
        let element_map = borrow_element_map(biomass_metadata, element_name);
        *simple_map::borrow(element_map, &affinity_name)
    }

    inline fun borrow_mut_element_map(
        biomass_metadata: &mut BiomassMetadata,
        element: String,
    ): &mut SimpleMap<String, address> {
        simple_map::borrow_mut(&mut biomass_metadata.address_map, &element)
    }

    inline fun borrow_element_map(
        biomass_metadata: &BiomassMetadata,
        element: String,
    ): &SimpleMap<String, address> {
        simple_map::borrow(&biomass_metadata.address_map, &element)
    }

    public(friend) fun create_base_fungible_token(director: &signer) acquires BiomassMetadata {
        access_control::assert_is_director(director);
        let element_types = enums::get_element_names();
        let affinity_types = enums::get_affinity_names();
        vector::for_each(element_types, |element_name| {
            if (element_name == enums::name<None>()) {
                vector::for_each(affinity_types, |affinity_name| {
                    if (affinity_name == enums::name<Balanced>()) {
                        create<None, Balanced>(
                            director,
                            string::utf8(BALANCED_BIOMASS_NAME),
                            enums::name<Balanced>(),
                            string::utf8(BALANCED_BIOMASS_IMAGE)
                        );
                    } else if (affinity_name == enums::name<Solid>()) {
                        create<None, Solid>(
                            director,
                            string::utf8(SOLID_BIOMASS_NAME),
                            enums::name<Solid>(),
                            string::utf8(SOLID_BIOMASS_IMAGE)
                        );
                    } else if (affinity_name == enums::name<Swift>()) {
                        create<None, Swift>(
                            director,
                            string::utf8(SWIFT_BIOMASS_NAME),
                            enums::name<Swift>(),
                            string::utf8(SWIFT_BIOMASS_IMAGE)
                        );
                    } else {
                        abort 1337900142069
                    };
                });
            } else {
                // initial mint has 0 elements on biomass
                // TODO: Add the initial creation of these later.
                abort 1337900142069
            }
        });
    }

    inline fun set_biomass_addr<Element, Affinity>(
        biomass_obj: Object<Biomass<Element, Affinity>>,
    ) {
        let biomass_metadata = borrow_global_mut<BiomassMetadata>(@mojo_monsters);
        let element_map = borrow_mut_element_map(biomass_metadata, enums::name<Element>());
        let biomass_addr = object::object_address(&biomass_obj);
        simple_map::add(element_map, enums::name<Affinity>(), biomass_addr);
    }

    public(friend) fun mint<Element, Affinity>(
        director: &signer,
        biomass_addr: address,
        to: address,
    ) {
        access_control::assert_is_director(director);
        assert!(exists<Biomass<Element, Affinity>>(biomass_addr), mojo_errors::invalid_biomass());
        let biomass_obj = object::address_to_object<Metadata>(biomass_addr);
        fungible_token_manager::mint_to_primary_stores(
            director,
            biomass_obj,
            vector<address> [ to ],
            vector<u64> [ 1 ],
        );
    }

    public(friend) fun create<Element, Affinity>(
        director: &signer,
        name: String,
        symbol: String,
        icon_uri: String,
    ): Object<Biomass<Element, Affinity>> acquires BiomassMetadata {
        access_control::assert_is_director(director);
        type_discriminators::assert_is_element<Element>();
        type_discriminators::assert_is_affinity<Affinity>();

        let director_addr = signer::address_of(director);
        let constructor_ref = object::create_object(director_addr);
        let (obj_signer, obj_addr) = object_refs::create_refs<Token>(&constructor_ref);
        move_to(
            &obj_signer,
            Biomass<Element, Affinity> { }
        );
        let biomass_obj = object::address_to_object<Biomass<Element, Affinity>>(obj_addr);
        fungible_token_manager::initialize(
            &constructor_ref,
            BIOMASS_MAX_SUPPLY,
            name,
            symbol,
            utils::get_decimals(),
            icon_uri,
            utils::get_project_uri(),
        );
        set_biomass_addr(biomass_obj);
        biomass_obj
    }

    // This solely deletes the Cauldron<Element> resource, not the underlying object or token.
    public(friend) fun destroy<Element, Affinity>(
        obj_addr: address
    ) acquires Biomass {
        let Biomass { } = move_from<Biomass<Element, Affinity>>(obj_addr);
    }
}
