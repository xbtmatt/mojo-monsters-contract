#[test_only]
module mojo_monsters::test_setup {
    public fun init(deployer: &signer) {
        mojo_monsters::stats::init_module_for_test(deployer);
    }
}