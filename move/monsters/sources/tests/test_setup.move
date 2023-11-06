#[test_only]
module mojo_monsters::test_setup {
    use aptos_framework::features;

    public fun init(deployer: &signer, aptos_framework: &signer) {
        enable_features_for_test(aptos_framework);
        mojo_monsters::director::init_module_for_test(deployer);
        mojo_monsters::stats::init_module_for_test(deployer);
    }

    public fun enable_features_for_test(aptos_framework: &signer) {
        let auids = features::get_auids();
        let concurrent_assets = features::get_concurrent_assets_feature();
        let module_events = features::get_module_event_feature();
        features::change_feature_flags(aptos_framework, vector[auids, concurrent_assets, module_events], vector[]);
    }
}
