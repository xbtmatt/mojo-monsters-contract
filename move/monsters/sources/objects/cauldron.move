module mojo_monsters::cauldron {
    use std::signer;
    // use mojo_monsters::element;
    use mojo_monsters::object_refs;
    use aptos_framework::object::{Self};
    use aptos_token_objects::token::{Token};

    struct Cauldron<phantom Element> has key { }

    public(friend) fun create<Element>(
        for: &signer,
    ) {
        let for_addr = signer::address_of(for);
        let constructor_ref = object::create_object(for_addr);
        let (obj_signer, obj_addr) = object_refs::create_refs<Token>(&constructor_ref);
        let _ = obj_signer;
        let _ = obj_addr;
        // assert!(is_element)     
 
    }

}