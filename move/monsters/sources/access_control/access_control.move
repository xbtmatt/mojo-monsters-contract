module mojo_monsters::access_control {
    use std::signer;
    use mojo_monsters::mojo_errors;
    use aptos_framework::object::{Self, Object};
    use mojo_monsters::director::{Self, Director};

    public fun assert_is_deployer(deployer: &signer) {
        let deployer_addr = signer::address_of(deployer);
        assert!(deployer_addr == @mojo_monsters, mojo_errors::not_authorized());
    }

    public fun assert_is_director_owner(deployer: &signer, director_obj: Object<Director>) {
        let deployer_addr = signer::address_of(deployer);
        assert!(object::is_owner(director_obj, deployer_addr), mojo_errors::not_authorized());
    }

    public fun assert_is_director(director: &signer) {
        assert!(director::is_director(director), mojo_errors::not_authorized());
    }
}
