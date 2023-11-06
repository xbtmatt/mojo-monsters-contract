module mojo_monsters::object_refs {
    use aptos_framework::object::{Self, ExtendRef, TransferRef, DeleteRef, ConstructorRef, LinearTransferRef};
    use aptos_token_objects::token::{Self, Token, BurnRef};
    use std::option::{Self, Option};
    use std::type_info::{type_of};
    use std::error;

    friend mojo_monsters::player;
    friend mojo_monsters::director;
    friend mojo_monsters::sack;
    friend mojo_monsters::cauldron;
    friend mojo_monsters::biomass;
    friend mojo_monsters::monster;
    friend mojo_monsters::start;

    /// That object doesn't have valid Refs (capabilities) on it.
    const EOBJECT_HAS_NO_REFS: u64 = 0;

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    struct Refs has key {
        extend_ref: ExtendRef,
        transfer_ref: TransferRef,
        delete_ref: DeleteRef,  // for basic objects
        burn_ref: Option<BurnRef>,
    }

    public(friend) fun get_signer(obj_addr: address): signer acquires Refs {
        assert!(exists<Refs>(obj_addr), error::invalid_argument(EOBJECT_HAS_NO_REFS));
        let refs = borrow_global<Refs>(obj_addr);
        object::generate_signer_for_extending(&refs.extend_ref)
    }

    public(friend) fun get_linear_transfer_ref(obj_addr: address): LinearTransferRef acquires Refs {
        assert!(exists<Refs>(obj_addr), error::invalid_argument(EOBJECT_HAS_NO_REFS));
        let refs = borrow_global<Refs>(obj_addr);
        object::generate_linear_transfer_ref(&refs.transfer_ref)
    }

    public(friend) fun create_refs<T: key>(constructor_ref: &ConstructorRef): (signer, address) {
        let extend_ref = object::generate_extend_ref(constructor_ref);
        let transfer_ref = object::generate_transfer_ref(constructor_ref);
        let delete_ref = object::generate_delete_ref(constructor_ref);
        let obj_signer = object::generate_signer(constructor_ref);
        let burn_ref = if (type_of<T>() == type_of<Token>()) {
            let burn_ref = token::generate_burn_ref(constructor_ref);
            option::some<BurnRef>(burn_ref)
        } else {
            option::none<BurnRef>()
        };
        object::disable_ungated_transfer(&transfer_ref);
        move_to(
            &obj_signer,
            Refs {
                extend_ref,
                transfer_ref,
                delete_ref,
                burn_ref,
            },
        );
        (obj_signer, object::address_from_constructor_ref(constructor_ref))
    }

    public(friend) fun destroy_object(obj_addr: address) acquires Refs {
        let Refs {
            extend_ref: _,
            transfer_ref: _,
            delete_ref,
            burn_ref: _,
        } = move_from<Refs>(obj_addr);
        object::delete(delete_ref);
    }

    public(friend) fun destroy_for_token(tournament_token_addr: address): BurnRef acquires Refs {
        let Refs {
            extend_ref: _,
            transfer_ref: _,
            delete_ref: _,
            burn_ref,
        } = move_from<Refs>(tournament_token_addr);

        option::extract(&mut burn_ref)
    }
}
