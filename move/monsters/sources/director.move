/// The creator of the collection and most tokens/objects in the contract.
module mojo_monsters::director {
    use std::signer;
    use aptos_framework::object;
    use mojo_monsters::mojo_errors;
    use mojo_monsters::object_refs;

    friend mojo_monsters::initialize;

    struct Director has key {
        director_addr: address,
    }

    // see `start.move` for initial setup order
    public(friend) fun init(deployer: &signer) {
        let deployer_addr = signer::address_of(deployer);
        assert!(deployer_addr == @mojo_monsters, mojo_errors::not_authorized());
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

    public fun is_director_object(given_director_addr: address): bool acquires Director {
        let (_, director_addr) = get_director();
        given_director_addr == director_addr
    }
}
