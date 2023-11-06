/// The creator of the collection and most tokens/objects in the contract.
module mojo_monsters::director {
    use std::signer;
    use aptos_framework::object;
    use mojo_monsters::object_refs;

    struct Director has key {
        director_addr: address,
    }

    fun init_module(deployer: &signer) {
        let deployer_addr = signer::address_of(deployer);
        let constructor_ref = object::create_object(deployer_addr);
        let (_, director_addr) = object_refs::create_refs<Director>(&constructor_ref);
        move_to(
            deployer,
            Director {
                director_addr: director_addr,
            }
        );
    }

    public(friend) fun get_director(): (signer, address) acquires Director {
        let director_addr = borrow_global<Director>(@mojo_monsters).director_addr;
        (object_refs::get_signer(director_addr), director_addr)
    }

    public fun is_director(director: &signer): bool acquires Director {
        let (director_signer, _) = get_director();
        signer::address_of(director) == signer::address_of(&director_signer)
    }

    #[test_only]
    public fun init_module_for_test(deployer: &signer) {
        init_module(deployer);
    }
}
