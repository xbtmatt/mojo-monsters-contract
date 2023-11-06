#[test_only]
module mojo_monsters::test_utils {
    use aptos_framework::features;

    public fun setup_test(deployer: &signer, aptos_framework: &signer) {
        enable_features_for_test(aptos_framework);
        mojo_monsters::initialize::init(deployer);
    }

    public fun enable_features_for_test(aptos_framework: &signer) {
        let auids = features::get_auids();
        let concurrent_assets = features::get_concurrent_assets_feature();
        let module_events = features::get_module_event_feature();
        features::change_feature_flags(aptos_framework, vector[auids, concurrent_assets, module_events], vector[]);
    }
}
