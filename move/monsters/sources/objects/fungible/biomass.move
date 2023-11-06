module mojo_monsters::biomass {
    use std::signer;
    use mojo_monsters::object_refs;
    use mojo_monsters::type_discriminators;
    use mojo_monsters::access_control;
    use aptos_framework::object::{Self, Object};
    use aptos_token_objects::token::{Token};

    struct Biomass<phantom Element, phantom Affinity> has key { }

    public(friend) fun create_base_fungible_token(director: &signer) {
        access_control::assert_is_director(director);

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
