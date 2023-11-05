module mojo_monsters::stats {
    use std::error;
    use std::vector;
    use std::signer;
    use aptos_framework::simple_map::{Self, SimpleMap};
    use std::string::{Self, String};
    use mojo_monsters::enums;

    const MAX_ENERGY: vector<u8> = b"MAX_ENERGY";
    const ENERGY_RECHARGE_RATE: vector<u8> = b"ENERGY_RECHARGE_RATE";
    const ENERGY_EFFICIENCY: vector<u8> = b"ENERGY_EFFICIENCY";
    const MAX_HUNGER: vector<u8> = b"MAX_HUNGER";
    const HUNGER_RESISTANCE: vector<u8> = b"HUNGER_RESISTANCE";
    const MAX_THIRST: vector<u8> = b"MAX_THIRST";
    const THIRST_RESISTANCE: vector<u8> = b"THIRST_RESISTANCE";
    const MAX_HAPPINESS: vector<u8> = b"MAX_HAPPINESS";
    const MAX_JOY: vector<u8> = b"MAX_JOY";
    const JOY_RESPONSE: vector<u8> = b"JOY_RESPONSE";
    const JOY_ABILITY: vector<u8> = b"JOY_ABILITY";
    const MAX_IMMUNITY: vector<u8> = b"MAX_IMMUNITY";
    const IMMUNITY_THRESHOLD: vector<u8> = b"IMMUNITY_THRESHOLD";
    const IMMUNITY_PERSISTENCE: vector<u8> = b"IMMUNITY_PERSISTENCE";
    const MAX_INTELLIGENCE: vector<u8> = b"MAX_INTELLIGENCE";
    const INTELLIGENCE_POTENTIAL: vector<u8> = b"INTELLIGENCE_POTENTIAL";

    const ELEMENT_NAMES: vector<vector<u8>> = vector<vector<u8>> [ b"FIRE", b"EARTH", b"WATER", b"AIR", b"CRYSTAL", b"ELECTRICITY", b"ETHER" ];
    const AFFINITY_NAMES: vector<vector<u8>> = vector<vector<u8>>[ b"SOLID", b"SWIFT", b"HARMONIC", b"PSYCHE", b"ADAPTIVE", b"DISRUPTIVE" ];

    /// You are not authorized to perform this action.
    const E_NOT_AUTHORIZED: u64 = 0;
    /// Vector lengths do not match.
    const E_VECTOR_LENGTHS_DO_NOT_MATCH: u64 = 1;
    /// Not enough types to match the number of enums required.
    const E_INCORRECT_NUM_ENUMS: u64 = 2;

    struct GameData has key {
        data: SimpleMap<String, SimpleMap<String, u64>>,
    }

    struct GameStat has copy, drop, store {
        outer_key: String,
        map: SimpleMap<String, I64>,
    }

    struct I64 has copy, drop, store {
        pos: bool,
        value: u64,
    }

    inline fun add_I64(a: I64, b: I64): I64 {
        if (a.pos == b.pos) {
            I64 { pos: a.pos, value: a.value + b.value }
        } else {
            if (a.value > b.value) {
                I64 { pos: a.pos, value: a.value - b.value }
            } else {
                I64 { pos: b.pos, value: b.value - a.value }
            }
        }
    }

    // purely for readability/maintainability's sake
    inline fun create_game_stat(key: String, inner_keys: vector<String>, stat: vector<I64>): SimpleMap<String, SimpleMap<String, I64>> {
        let inner_maps = simple_map::new_from(inner_keys, stat);
        simple_map::new_from(vector<String> [ key ], vector<SimpleMap<String, I64>> [ inner_maps ])
    }

    inline fun pos(i: u64): I64 {
        I64 { pos: true, value: i }
    }

    inline fun neg(i: u64): I64 {
        I64 { pos: false, value: i }
    }

    inline fun zero(): I64 {
        I64 { pos: true, value: 0 }
    }

    inline fun spreadsheet(): vector<vector<I64>> {
        // Element,Energy Capacity,Energy Recharge Rate,Energy Efficiency,Hunger Capacity,Hunger Resistance,Thirst Capacity,Thirst Resistance,Happiness Capacity,Joy Response,joy ability,Immunity Threshold,Immunity Persistence,Inherent Intelligence,Learning Potential
        let spreadsheet_data = vector<vector<I64>> [
            vector<I64> [ pos(20), pos(20), neg(10), zero(),  neg(10), zero(),  neg(10), zero(),  zero(),  zero(),  zero(),  zero(),  zero(),  zero()  ],  // Fire
            vector<I64> [ zero(),  zero(),  pos(10), zero(),  zero(),  zero(),  zero(),  zero(),  zero(),  zero(),  zero(),  pos(10), zero(),  neg(10) ],  // Earth
            vector<I64> [ zero(),  pos(10), zero(),  neg(10), pos(10), neg(10), pos(10), zero(),  zero(),  zero(),  zero(),  zero(),  zero(),  zero()  ],  // Water
            vector<I64> [ neg(10), zero(),  pos(10), zero(),  neg(10), zero(),  neg(10), zero(),  pos(20), zero(),  zero(),  zero(),  zero(),  zero()  ],  // Air
            vector<I64> [ zero(),  zero(),  pos(10), zero(),  zero(),  zero(),  zero(),  zero(),  zero(),  zero(),  pos(10), pos(10), pos(10), zero()  ],  // Crystal
            vector<I64> [ pos(30), pos(30), pos(30), zero(),  neg(20), zero(),  neg(20), pos(20), pos(20), zero(),  zero(),  zero(),  zero(),  zero()  ],  // Electricity
            vector<I64> [ pos(20), zero(),  pos(20), zero(),  pos(20), zero(),  pos(20), neg(20), neg(20), zero(),  pos(20), pos(20), pos(20), pos(20) ],  // Ether
            vector<I64> [ pos(20), neg(10), neg(10), zero(),  zero(),  zero(),  zero(),  zero(),  zero(),  zero(),  zero(),  pos(10), zero(),  zero()  ],  // Solid
            vector<I64> [ zero(),  pos(20), zero(),  zero(),  neg(20), zero(),  neg(20), zero(),  pos(10), zero(),  zero(),  neg(10), zero(),  zero()  ],  // Swift
            vector<I64> [ neg(10), zero(),  pos(10), zero(),  pos(10), zero(),  pos(10), zero(),  pos(20), pos(20), zero(),  zero(),  zero(),  zero()  ],  // Harmonic
            vector<I64> [ zero(),  zero(),  zero(),  zero(),  zero(),  zero(),  zero(),  pos(10), neg(10), zero(),  neg(10), neg(10), pos(20), pos(20) ],  // Psyche
            vector<I64> [ zero(),  zero(),  zero(),  zero(),  pos(10), zero(),  pos(10), zero(),  zero(),  zero(),  pos(20), pos(20), pos(10), zero()  ],  // Adaptive
            vector<I64> [ pos(20), pos(20), neg(20), zero(),  zero(),  zero(),  zero(),  pos(20), neg(10), neg(10), zero(),  zero(),  zero(),  zero(), ], // Disruptive
        ];

        let first_el = vector::borrow(&spreadsheet_data, 0);
        let all_equal_length = vector::all(&spreadsheet_data, |v| {
            vector::length<I64>(v) == vector::length<I64>(first_el)
        });
        assert!(all_equal_length, error::invalid_argument(E_VECTOR_LENGTHS_DO_NOT_MATCH));

        let outer_spreadsheet_vector_length = vector::length(&spreadsheet_data);
        let num_element_names = vector::length(&enums::get_element_names());
        let num_affinity_names = vector::length(&enums::get_affinity_names());
        assert!(outer_spreadsheet_vector_length == (num_element_names + num_affinity_names), error::invalid_argument(E_INCORRECT_NUM_ENUMS));

        transpose(spreadsheet_data)
    }

    inline fun transpose<T: copy + drop + store>(v: vector<vector<T>>): vector<vector<T>> {
        let first_el = vector::borrow(&v, 0);
        let all_equal_length = vector::all(&v, |vv| {
            vector::length<T>(vv) == vector::length<T>(first_el)
        });
        assert!(all_equal_length, error::invalid_argument(E_VECTOR_LENGTHS_DO_NOT_MATCH));

        let new_outer = vector<vector<T>> [];
        vector::enumerate_ref(&v, |i, vv| {
            if (i == 0) {
                // initialize the new outer vector
                vector::for_each_ref(vv, |_vvv| {
                    vector::push_back(&mut new_outer, vector<T> []);
                });
            };
            vector::enumerate_ref(vv, |ii, vvv| {
                let transposed = vector::borrow_mut(&mut new_outer, ii);
                vector::push_back(transposed, *vvv);
            });
        });
        new_outer
    }

    fun init_module(deployer: &signer) {
        assert!(signer::address_of(deployer) == @mojo_monsters, error::permission_denied(E_NOT_AUTHORIZED));

        let inner_keys = vector<String> [];
        vector::append(&mut inner_keys, enums::get_element_names());
        vector::append(&mut inner_keys, enums::get_affinity_names());

        let d = spreadsheet();
        // index 1 == Fire: Energy Capacity, Energy Recharge Rate, Energy Efficiency, Hunger Capacity, Hunger Resistance, Thirst Capacity, Thirst Resistance, Happiness Capacity, Joy Response, joy ability, Immunity Threshold, Immunity Persistence, Inherent Intelligence, Learning Potential
        // index 2 == Earth: Energy Capacity, Energy Recharge Rate, Energy Efficiency, Hunger Capacity, Hunger Resistance, Thirst Capacity, Thirst Resistance, Happiness Capacity, Joy Response, joy ability, Immunity Threshold, Immunity Persistence, Inherent Intelligence, Learning Potential
        // etc...

        // fire, earth, water, air, crystal, electricity, ether, solid, swift, harmonic, psyche, adaptive, disruptive
        let game_stats = vector<SimpleMap<String, SimpleMap<String, I64>>> [
            create_game_stat(string::utf8(MAX_ENERGY), inner_keys, *vector::borrow(&d, 0)),
            create_game_stat(string::utf8(ENERGY_RECHARGE_RATE), inner_keys, *vector::borrow(&d, 1)),
            create_game_stat(string::utf8(ENERGY_EFFICIENCY), inner_keys, *vector::borrow(&d, 1)),
            create_game_stat(string::utf8(MAX_HUNGER), inner_keys, *vector::borrow(&d, 1)),
            create_game_stat(string::utf8(HUNGER_RESISTANCE), inner_keys, *vector::borrow(&d, 1)),
            create_game_stat(string::utf8(MAX_THIRST), inner_keys, *vector::borrow(&d, 1)),
            create_game_stat(string::utf8(THIRST_RESISTANCE), inner_keys, *vector::borrow(&d, 1)),
            create_game_stat(string::utf8(MAX_HAPPINESS), inner_keys, *vector::borrow(&d, 1)),
            create_game_stat(string::utf8(MAX_JOY), inner_keys, *vector::borrow(&d, 1)),
            create_game_stat(string::utf8(JOY_RESPONSE), inner_keys, *vector::borrow(&d, 1)),
            create_game_stat(string::utf8(JOY_ABILITY), inner_keys, *vector::borrow(&d, 1)),
            create_game_stat(string::utf8(MAX_IMMUNITY), inner_keys, *vector::borrow(&d, 1)),
            create_game_stat(string::utf8(IMMUNITY_THRESHOLD), inner_keys, *vector::borrow(&d, 1)),
            create_game_stat(string::utf8(IMMUNITY_PERSISTENCE), inner_keys, *vector::borrow(&d, 1)),
            create_game_stat(string::utf8(MAX_INTELLIGENCE), inner_keys, *vector::borrow(&d, 1)),
            create_game_stat(string::utf8(INTELLIGENCE_POTENTIAL), inner_keys, *vector::borrow(&d, 1)),
        ];

        std::debug::print(&game_stats);

        // let multiplier_keys = 
        // let multipliers: SimpleMap<string, u64> = SimpleMap<string, u64> {


        // move_to(
        //     deployer,
        //     GameData {
        //         data: simple_map::new_from(data, multipliers),
        //     }
        // );
    }


    fun get_multiplier<T>(_multiplier_name: String): u64 {
        // TODO
        // use the stats from game_stats // create_game_stats
        0
    }

    #[test]
    fun test_transpose() {
        let vec1 = vector<u8> [ 0, 1, 2, 3, 4 ];
        let vec2 = vector<u8> [ 1, 1, 1, 1, 1 ];
        let vec3 = vector<u8> [ 2, 2, 2, 2, 2 ];
        let vecvec = vector<vector<u8>> [ vec1, vec2, vec3 ];
        let transposed = transpose(vecvec);

        assert!(transposed == vector<vector<u8>>[
            vector<u8> [ 0, 1, 2 ],
            vector<u8> [ 1, 1, 2 ],
            vector<u8> [ 2, 1, 2 ],
            vector<u8> [ 3, 1, 2 ],
            vector<u8> [ 4, 1, 2 ],
        ], 0);
        std::debug::print(&vecvec);
        std::debug::print(&transposed);
    }

    // #[test_only] use std::string::{Self};

    #[test_only]
    fun test_stats_name_indexes_correct() {
        assert!(vector::map(ELEMENT_NAMES, |e| { string::utf8(e) }) == enums::get_element_names(), 0);
        assert!(vector::map(AFFINITY_NAMES, |e| { string::utf8(e) }) == enums::get_element_names(), 0);
    }

    #[test (asdf=@mojo_monsters)]
    fun test_init_module(
        asdf: &signer
    ) {
        init_module(asdf);
    }

}