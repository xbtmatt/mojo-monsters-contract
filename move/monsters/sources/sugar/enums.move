module mojo_monsters::enums {
    use std::string::{Self, String};
    use aptos_std::type_info::{type_of};
    use mojo_monsters::elements::{Fire, Earth, Water, Air, Crystal, Electricity, Ether};
    use mojo_monsters::affinity::{Solid, Swift, Harmonic, Psyche, Adaptive, Disruptive};
    use std::error;
    use std::vector;

    /// You have provided an invalid type.
    const E_INVALID_TYPE: u64 = 0;

    // Elements
    // ---------------------------------------------------------------
    const FIRE: vector<u8> = b"FIRE";
    const EARTH: vector<u8> = b"EARTH";
    const WATER: vector<u8> = b"WATER";
    const AIR: vector<u8> = b"AIR";
    const CRYSTAL: vector<u8> = b"CRYSTAL";
    const ELECTRICITY: vector<u8> = b"ELECTRICITY";
    const ETHER: vector<u8> = b"ETHER";
    const ELEMENT_NAMES: vector<vector<u8>> = vector<vector<u8>> [ b"FIRE", b"EARTH", b"WATER", b"AIR", b"CRYSTAL", b"ELECTRICITY", b"ETHER" ];
    const ELEMENT_INDEX: vector<u8> = vector<u8> [ 0, 1, 2, 3, 4, 5, 6 ];

    // Affinities
    // ---------------------------------------------------------------
    const SOLID: vector<u8> = b"SOLID";
    const SWIFT: vector<u8> = b"SWIFT";
    const HARMONIC: vector<u8> = b"HARMONIC";
    const PSYCHE: vector<u8> = b"PSYCHE";
    const ADAPTIVE: vector<u8> = b"ADAPTIVE";
    const DISRUPTIVE: vector<u8> = b"DISRUPTIVE";
    const AFFINITY_NAMES: vector<vector<u8>> = vector<vector<u8>>[ b"SOLID", b"SWIFT", b"HARMONIC", b"PSYCHE", b"ADAPTIVE", b"DISRUPTIVE" ];
    const AFFINITY_INDEX: vector<u8> = vector<u8>[ 0, 1, 2, 3, 4, 5 ];

    // Attributes (element + affinity)
    // ---------------------------------------------------------------
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

    public inline fun get_element_names(): vector<String> {
        vector::map_ref(&ELEMENT_NAMES, |x| { string::utf8(*x) })
    }
    
    public inline fun get_affinity_names(): vector<String> {
        vector::map_ref(&AFFINITY_NAMES, |x| { string::utf8(*x) })
    }

    public inline fun fire(): String { string::utf8(FIRE) }
    public inline fun earth(): String { string::utf8(EARTH) }
    public inline fun water(): String { string::utf8(WATER) }
    public inline fun air(): String { string::utf8(AIR) }
    public inline fun crystal(): String { string::utf8(CRYSTAL) }
    public inline fun electricity(): String { string::utf8(ELECTRICITY) }
    public inline fun ether(): String { string::utf8(ETHER) }

    public inline fun solid(): String { string::utf8(SOLID) }
    public inline fun swift(): String { string::utf8(SWIFT) }
    public inline fun harmonic(): String { string::utf8(HARMONIC) }
    public inline fun psyche(): String { string::utf8(PSYCHE) }
    public inline fun adaptive(): String { string::utf8(ADAPTIVE) }
    public inline fun disruptive(): String { string::utf8(DISRUPTIVE) }
    
    public inline fun element_name<T>(): String {
        // elements
        if (type_of<T>() == type_of<Fire>())        { return fire() };
        if (type_of<T>() == type_of<Earth>())       { return earth() };
        if (type_of<T>() == type_of<Water>())       { return water() };
        if (type_of<T>() == type_of<Air>())         { return air() };
        if (type_of<T>() == type_of<Crystal>())     { return crystal() };
        if (type_of<T>() == type_of<Electricity>()) { return electricity() };
        if (type_of<T>() == type_of<Ether>())       { return ether() };
        abort error::invalid_argument(E_INVALID_TYPE)
    }

    public inline fun affinity_name<T>(): String {
        if (type_of<T>() == type_of<Solid>())       { return solid() };
        if (type_of<T>() == type_of<Swift>())       { return swift() };
        if (type_of<T>() == type_of<Harmonic>())    { return harmonic() };
        if (type_of<T>() == type_of<Psyche>())      { return psyche() };
        if (type_of<T>() == type_of<Adaptive>())    { return adaptive() };
        if (type_of<T>() == type_of<Disruptive>())  { return disruptive() };
        abort error::invalid_argument(E_INVALID_TYPE)
    }

    public inline fun element<T>(): u8 {
        if (type_of<T>() == type_of<Fire>())        { return 0 };
        if (type_of<T>() == type_of<Earth>())       { return 1 };
        if (type_of<T>() == type_of<Water>())       { return 2 };
        if (type_of<T>() == type_of<Air>())         { return 3 };
        if (type_of<T>() == type_of<Crystal>())     { return 4 };
        if (type_of<T>() == type_of<Electricity>()) { return 5 };
        if (type_of<T>() == type_of<Ether>())       { return 6 };
        abort error::invalid_argument(E_INVALID_TYPE)
    }
    
    public inline fun affinity<T>(): u8 {
        if (type_of<T>() == type_of<Solid>())       { return 0 };
        if (type_of<T>() == type_of<Swift>())       { return 1 };
        if (type_of<T>() == type_of<Harmonic>())    { return 2 };
        if (type_of<T>() == type_of<Psyche>())      { return 3 };
        if (type_of<T>() == type_of<Adaptive>())    { return 4 };
        if (type_of<T>() == type_of<Disruptive>())  { return 5 };
        abort error::invalid_argument(E_INVALID_TYPE)
    }

    public inline fun element_name_index(s: String): u8 {
        if (s == fire())        { return 0 };
        if (s == earth())       { return 1 };
        if (s == water())       { return 2 };
        if (s == air())         { return 3 };
        if (s == crystal())     { return 4 };
        if (s == electricity()) { return 5 };
        if (s == ether())       { return 6 };
        abort error::invalid_argument(E_INVALID_TYPE)
    }

    public inline fun affinity_name_index(s: String): u8 {
        if (s == solid())       { return 0 };
        if (s == swift())       { return 1 };
        if (s == harmonic())    { return 2 };
        if (s == psyche())      { return 3 };
        if (s == adaptive())    { return 4 };
        if (s == disruptive())  { return 5 };
        abort error::invalid_argument(E_INVALID_TYPE)
    }

    public inline fun attribute(s: String): u8 {
        if (s == string::utf8(MAX_ENERGY))              { return 0 };
        if (s == string::utf8(ENERGY_RECHARGE_RATE))    { return 1 };
        if (s == string::utf8(ENERGY_EFFICIENCY))       { return 2 };
        if (s == string::utf8(MAX_HUNGER))              { return 3 };
        if (s == string::utf8(HUNGER_RESISTANCE))       { return 4 };
        if (s == string::utf8(MAX_THIRST))              { return 5 };
        if (s == string::utf8(THIRST_RESISTANCE))       { return 6 };
        if (s == string::utf8(MAX_HAPPINESS))           { return 7 };
        if (s == string::utf8(MAX_JOY))                 { return 8 };
        if (s == string::utf8(JOY_RESPONSE))            { return 9 };
        if (s == string::utf8(JOY_ABILITY))             { return 10 };
        if (s == string::utf8(MAX_IMMUNITY))            { return 11 };
        if (s == string::utf8(IMMUNITY_THRESHOLD))      { return 12 };
        if (s == string::utf8(IMMUNITY_PERSISTENCE))    { return 13 };
        if (s == string::utf8(MAX_INTELLIGENCE))        { return 14 };
        if (s == string::utf8(INTELLIGENCE_POTENTIAL))  { return 15 };
        abort error::invalid_argument(E_INVALID_TYPE)
    }
}

module mojo_monsters::enums_tests {
    #[test_only] use std::vector;

    #[test_only] use std::string::{Self};
    #[test_only] use mojo_monsters::elements::{Fire, Earth, Water, Air, Crystal, Electricity, Ether};
    #[test_only] use mojo_monsters::affinity::{Solid, Swift, Harmonic, Psyche, Adaptive, Disruptive};
    #[test_only] use mojo_monsters::enums::{element_name, affinity_name, element_name_index, element, affinity, affinity_name_index, get_element_names, get_affinity_names};
    #[test_only] use mojo_monsters::enums::{fire, earth, water, air, crystal, electricity, ether, solid, swift, harmonic, psyche, adaptive, disruptive};

    #[test]
    fun test_enum_indices() {
        assert!(element_name<Fire>() == fire(), 0);
        assert!(element_name<Earth>() == earth(), 0);
        assert!(element_name<Water>() == water(), 0);
        assert!(element_name<Air>() == air(), 0);
        assert!(element_name<Crystal>() == crystal(), 0);
        assert!(element_name<Electricity>() == electricity(), 0);
        assert!(element_name<Ether>() == ether(), 0);

        assert!(affinity_name<Solid>() == solid(), 0);
        assert!(affinity_name<Swift>() == swift(), 0);
        assert!(affinity_name<Harmonic>() == harmonic(), 0);
        assert!(affinity_name<Psyche>() == psyche(), 0);
        assert!(affinity_name<Adaptive>() == adaptive(), 0);
        assert!(affinity_name<Disruptive>() == disruptive(), 0);

        assert!(element_name_index(element_name<Fire>()) == element<Fire>(), 0);
        assert!(element_name_index(element_name<Earth>()) == element<Earth>(), 0);
        assert!(element_name_index(element_name<Water>()) == element<Water>(), 0);
        assert!(element_name_index(element_name<Air>()) == element<Air>(), 0);
        assert!(element_name_index(element_name<Crystal>()) == element<Crystal>(), 0);
        assert!(element_name_index(element_name<Electricity>()) == element<Electricity>(), 0);
        assert!(element_name_index(element_name<Ether>()) == element<Ether>(), 0);

        assert!(affinity_name_index(affinity_name<Solid>()) == affinity<Solid>(), 0);
        assert!(affinity_name_index(affinity_name<Swift>()) == affinity<Swift>(), 0);
        assert!(affinity_name_index(affinity_name<Harmonic>()) == affinity<Harmonic>(), 0);
        assert!(affinity_name_index(affinity_name<Psyche>()) == affinity<Psyche>(), 0);
        assert!(affinity_name_index(affinity_name<Adaptive>()) == affinity<Adaptive>(), 0);
        assert!(affinity_name_index(affinity_name<Disruptive>()) == affinity<Disruptive>(), 0);

        // we will likely copy and paste this a lot to use as fake enums...ensure it's accurate. (this is painful)
        vector::enumerate_ref(&get_element_names(), |i, e| {
            std::debug::print(&i);
            std::debug::print(e);
            assert!(element_name_index(*e) == (i as u8), 0);
            let a = vector::borrow(&get_affinity_names(), i);
            assert!(affinity_name_index(*a) == (i as u8), 0);
        });
    }

}