module mojo_monsters::vitals {
    use mojo_monsters::stats;
    use std::string;

    struct Vitals has key {
        energy: Energy,
        hunger: Hunger,
        joy: Joy,
        immunity: Immunity,
        intelligence: Intelligence,
    }

    struct Energy has copy, drop, store {
        current: u64,
        max: u64,
        recharge_rate: u64,
        efficiency: u64,
    }

    struct Hunger has copy, drop, store {
        current: u64,
        max: u64,
        resistance: u64,
    }

    struct Joy has copy, drop, store {
        current: u64,
        max: u64,
        response: u64,
        ability: u64,
    }

    struct Immunity has copy, drop, store {
        current: u64,
        max: u64,
        threshold: u64,
        persistence: u64,
    }

    struct Intelligence has copy, drop, store {
        current: u64,
        max: u64,
        inherent: u64,
        potential: u64,
    }

    const BASE_ATTRIBUTE_VALUE: u64 = 100;

    public(friend) fun init_vitals<Element, Affinity>(
        monster: &signer,
    ) {
        let max_energy = stats::get_starting_attribute<Element, Affinity>(BASE_ATTRIBUTE_VALUE, string::utf8(b"MAX_ENERGY"));
        let max_hunger = stats::get_starting_attribute<Element, Affinity>(BASE_ATTRIBUTE_VALUE, string::utf8(b"MAX_HUNGER"));
        let max_joy = stats::get_starting_attribute<Element, Affinity>(BASE_ATTRIBUTE_VALUE, string::utf8(b"MAX_JOY"));
        let max_immunity = stats::get_starting_attribute<Element, Affinity>(BASE_ATTRIBUTE_VALUE, string::utf8(b"MAX_IMMUNITY"));
        let max_intelligence = stats::get_starting_attribute<Element, Affinity>(BASE_ATTRIBUTE_VALUE, string::utf8(b"MAX_INTELLIGENCE"));

        move_to(
            monster,
            Vitals {
                energy: Energy {
                    current: max_energy,
                    max: max_energy,
                    recharge_rate: stats::get_starting_attribute<Element, Affinity>(BASE_ATTRIBUTE_VALUE, string::utf8(b"ENERGY_RECHARGE_RATE")),
                    efficiency: stats::get_starting_attribute<Element, Affinity>(BASE_ATTRIBUTE_VALUE, string::utf8(b"ENERGY_EFFICIENCY")),
                },
                hunger: Hunger {
                    current: max_hunger,
                    max: max_hunger,
                    resistance: stats::get_starting_attribute<Element, Affinity>(BASE_ATTRIBUTE_VALUE, string::utf8(b"HUNGER_RESISTANCE")),
                },
                joy: Joy {
                    current: max_joy,
                    max: max_joy,
                    response: stats::get_starting_attribute<Element, Affinity>(BASE_ATTRIBUTE_VALUE, string::utf8(b"JOY_RESPONSE")),
                    ability: stats::get_starting_attribute<Element, Affinity>(BASE_ATTRIBUTE_VALUE, string::utf8(b"JOY_ABILITY")),
                },
                immunity: Immunity {
                    current: max_immunity,
                    max: max_immunity,
                    threshold: stats::get_starting_attribute<Element, Affinity>(BASE_ATTRIBUTE_VALUE, string::utf8(b"IMMUNITY_THRESHOLD")),
                    persistence: stats::get_starting_attribute<Element, Affinity>(BASE_ATTRIBUTE_VALUE, string::utf8(b"IMMUNITY_PERSISTENCE")),
                },
                intelligence: Intelligence {
                    current: max_intelligence,
                    max: max_intelligence,
                    inherent: stats::get_starting_attribute<Element, Affinity>(BASE_ATTRIBUTE_VALUE, string::utf8(b"INHERENT_INTELLIGENCE")),
                    potential: stats::get_starting_attribute<Element, Affinity>(BASE_ATTRIBUTE_VALUE, string::utf8(b"INTELLIGENCE_POTENTIAL")),
                },
            },
        );
    }

    #[test_only] use std::signer;
    #[test_only] use mojo_monsters::element;
    #[test_only] use mojo_monsters::affinity;
    #[test_only] use mojo_monsters::vitals;
    #[test_only] use mojo_monsters::enums;

    #[test(deployer = @mojo_monsters)]
    fun test_happy_path(
        deployer: &signer
    ) acquires Vitals {
        mojo_monsters::test_setup::init(deployer);
        let deployer_addr = signer::address_of(deployer);
        init_vitals<element::Fire, affinity::Harmonic>(deployer);
        std::debug::print(&enums::name<element::Fire>());
        std::debug::print(&enums::name<affinity::Harmonic>());
        std::debug::print(borrow_global<vitals::Vitals>(deployer_addr));
    }



}