module mojo_monsters::sack {
    use mojo_monsters::access_control;
    
    friend mojo_monsters::initialize;

    struct Sack has store { }

    public(friend) fun init(director: &signer) {
        access_control::assert_is_director(director);
        //    
    }
}