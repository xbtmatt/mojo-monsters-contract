/// Exists solely to break the dependency cycle between `access_control.move` and `director.move`
module mojo_monsters::getter {
    use aptos_framework::object::{Self, Object};
    use mojo_monsters::director::{Self, Director};

    public fun is_director(director: &signer): bool {
        director::is_director(director)
    }

    public fun is_director_object(director_addr: address): bool {
        director::is_director_object(director_addr)
    }

    public fun to_director_object(director_addr: address): Object<Director> {
        object::address_to_object<Director>(director_addr)
    }
}
