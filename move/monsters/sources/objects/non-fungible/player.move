module mojo_monsters::player {
    use std::string::{String};
    use aptos_framework::object::{Object};
    use mojo_monsters::sack::{Sack};
    use aptos_std::simple_map::{SimpleMap};
    use mojo_monsters::access_control;

    friend mojo_monsters::initialize;

    struct Player has key {
        name: String,
        level: u64,
        experience: u64,
        achievements: SimpleMap<String, Object<Achievement>>,
        sack: Object<Sack>,
        traits: Traits,
    }

    struct Achievement has key {
        name: String,
        description: String,
        experience: u64,
    }

    struct Traits has store {
        artifact: Object<Artifact>,
        lineage: Object<Lineage>,
        clothing: Object<Clothing>,
    }

    struct Artifact has key {
        name: String,
        description: String,
        power: u64,
    }

    struct Lineage has key {
        name: String,
        description: String,
        power: u64,
    }

    struct Clothing has key {
        name: String,
        description: String,
        power: u64,
    }

    public(friend) fun init(director: &signer) {
        access_control::assert_is_director(director);
        //    
    }
}
