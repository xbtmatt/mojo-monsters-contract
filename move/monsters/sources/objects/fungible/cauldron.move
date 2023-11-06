module mojo_monsters::cauldron {
    use std::signer;
    use mojo_monsters::object_refs;
    use mojo_monsters::type_discriminators;
    use aptos_framework::object::{Self, Object};
    use aptos_token_objects::token::{Token};
    use mojo_monsters::access_control;
    friend mojo_monsters::initialize;

    struct Cauldron<phantom Element> has key { }

    public(friend) fun init(director: &signer) {
        access_control::assert_is_director(director);
        //    
    }

    public(friend) fun create<Element>(
        for: &signer,
    ): Object<Cauldron<Element>> {
        type_discriminators::assert_is_element<Element>();

        let for_addr = signer::address_of(for);
        let constructor_ref = object::create_object(for_addr);
        let (obj_signer, obj_addr) = object_refs::create_refs<Token>(&constructor_ref);
        move_to(
            &obj_signer,
            Cauldron<Element> { }
        );
        object::address_to_object<Cauldron<Element>>(obj_addr)
    }

    // This solely deletes the Cauldron<Element> resource, not the underlying object or token.
    public(friend) fun destroy<Element>(
        obj_addr: address
    ) acquires Cauldron {
        let Cauldron { } = move_from<Cauldron<Element>>(obj_addr);
    }
}
