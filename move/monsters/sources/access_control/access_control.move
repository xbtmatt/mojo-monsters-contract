module mojo_monsters::access_control {
    use std::signer;
    use mojo_monsters::mojo_errors;
    use aptos_framework::object::{Self};
    use mojo_monsters::getter::{Self};

    public fun assert_is_deployer(deployer: &signer) {
        let deployer_addr = signer::address_of(deployer);
        assert!(deployer_addr == @mojo_monsters, mojo_errors::not_authorized());
    }

    public fun assert_is_director_owner(deployer: &signer, director_addr: address) {
        let director_obj = getter::to_director_object(director_addr);
        let deployer_addr = signer::address_of(deployer);
        assert!(object::is_owner(director_obj, deployer_addr), mojo_errors::not_authorized());
    }

    public fun assert_is_director(director: &signer) {
        assert!(getter::is_director(director), mojo_errors::not_authorized());
    }
}
