module mojo_monsters::initialize {

    fun init_module(deployer: &signer) {
        init(deployer);
    }

    // We have to avoid `init_module` in other modules because we need to enforce a certain order.
    // We call each relevant module's `init` function here
    public fun init(deployer: &signer) {
        mojo_monsters::access_control::assert_is_deployer(deployer);
        mojo_monsters::stats::init(deployer);
        mojo_monsters::director::init(deployer);
        let (director, _) = mojo_monsters::director::get_director();
        mojo_monsters::biomass::init(&director);
        mojo_monsters::player::init(&director);
        mojo_monsters::sack::init(&director);
        mojo_monsters::cauldron::init(&director);
    }
}
