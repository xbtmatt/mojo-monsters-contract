module mojo_monsters::enums {
    use std::string::{Self, String};
    use aptos_std::type_info::{type_of};
    use mojo_monsters::elements::{Fire, Earth, Water, Air, Crystal, Electricity, Ether};
    use mojo_monsters::affinity::{Solid, Swift, Harmonic, Psyche, Adaptive, Disruptive};
    use std::error;
    use std::vector;

    /// You have provided an invalid type.
    const E_INVALID_TYPE: u64 = 0;

    const ELEMENT_NAMES: vector<vector<u8>> = vector<vector<u8>> [ b"FIRE", b"EARTH", b"WATER", b"AIR", b"CRYSTAL", b"ELECTRICITY", b"ETHER" ];
    const AFFINITY_NAMES: vector<vector<u8>> = vector<vector<u8>>[ b"SOLID", b"SWIFT", b"HARMONIC", b"PSYCHE", b"ADAPTIVE", b"DISRUPTIVE" ];

    public inline fun get_element_names(): vector<String> {
        // vector::map_ref(&ELEMENT_NAMES, |x| { string::utf8(*x) })
        vector::map_ref(&vector<vector<u8>> [ b"FIRE", b"EARTH", b"WATER", b"AIR", b"CRYSTAL", b"ELECTRICITY", b"ETHER" ], |x| { string::utf8(*x) })
    }
    
    public inline fun get_affinity_names(): vector<String> {
        // vector::map_ref(&AFFINITY_NAMES, |x| { string::utf8(*x) })
        vector::map_ref(&vector<vector<u8>>[ b"SOLID", b"SWIFT", b"HARMONIC", b"PSYCHE", b"ADAPTIVE", b"DISRUPTIVE" ], |x| { string::utf8(*x) })
    }

    public inline fun fire(): String { string::utf8(b"FIRE") }
    public inline fun earth(): String { string::utf8(b"EARTH") }
    public inline fun water(): String { string::utf8(b"WATER") }
    public inline fun air(): String { string::utf8(b"AIR") }
    public inline fun crystal(): String { string::utf8(b"CRYSTAL") }
    public inline fun electricity(): String { string::utf8(b"ELECTRICITY") }
    public inline fun ether(): String { string::utf8(b"ETHER") }

    public inline fun solid(): String { string::utf8(b"SOLID") }
    public inline fun swift(): String { string::utf8(b"SWIFT") }
    public inline fun harmonic(): String { string::utf8(b"HARMONIC") }
    public inline fun psyche(): String { string::utf8(b"PSYCHE") }
    public inline fun adaptive(): String { string::utf8(b"ADAPTIVE") }
    public inline fun disruptive(): String { string::utf8(b"DISRUPTIVE") }
    
    public inline fun element_name<T>(): String {
        // elements
             if (type_of<T>() == type_of<Fire>())        { fire() }
        else if (type_of<T>() == type_of<Earth>())       { earth() }
        else if (type_of<T>() == type_of<Water>())       { water() }
        else if (type_of<T>() == type_of<Air>())         { air() }
        else if (type_of<T>() == type_of<Crystal>())     { crystal() }
        else if (type_of<T>() == type_of<Electricity>()) { electricity() }
        else if (type_of<T>() == type_of<Ether>())       { ether() }
        else { abort error::invalid_argument(0) } // E_INVALID_TYPE
    }

    public inline fun affinity_name<T>(): String {
             if (type_of<T>() == type_of<Solid>())       { solid() }
        else if (type_of<T>() == type_of<Swift>())       { swift() }
        else if (type_of<T>() == type_of<Harmonic>())    { harmonic() }
        else if (type_of<T>() == type_of<Psyche>())      { psyche() }
        else if (type_of<T>() == type_of<Adaptive>())    { adaptive() }
        else if (type_of<T>() == type_of<Disruptive>())  { disruptive() }
        else { abort error::invalid_argument(0) } // E_INVALID_TYPE
    }

    // public inline fun element<T>(): u8 {
    public fun element<T>(): u8 {
             if (type_of<T>() == type_of<Fire>())        { 0 }
        else if (type_of<T>() == type_of<Earth>())       { 1 }
        else if (type_of<T>() == type_of<Water>())       { 2 }
        else if (type_of<T>() == type_of<Air>())         { 3 }
        else if (type_of<T>() == type_of<Crystal>())     { 4 }
        else if (type_of<T>() == type_of<Electricity>()) { 5 }
        else if (type_of<T>() == type_of<Ether>())       { 6 }
        else { abort error::invalid_argument(0) } // E_INVALID_TYPE
    }
    
    // public inline fun affinity<T>(): u8 {
    public fun affinity<T>(): u8 {
             if (type_of<T>() == type_of<Solid>())       { 0 }
        else if (type_of<T>() == type_of<Swift>())       { 1 }
        else if (type_of<T>() == type_of<Harmonic>())    { 2 }
        else if (type_of<T>() == type_of<Psyche>())      { 3 }
        else if (type_of<T>() == type_of<Adaptive>())    { 4 }
        else if (type_of<T>() == type_of<Disruptive>())  { 5 }
        else { abort error::invalid_argument(0) } // E_INVALID_TYPE
    }

    // public inline fun element_name_index(s: String): u8 {
    public fun element_name_index(s: String): u8 {
             if (s == fire())        { 0 }
        else if (s == earth())       { 1 }
        else if (s == water())       { 2 }
        else if (s == air())         { 3 }
        else if (s == crystal())     { 4 }
        else if (s == electricity()) { 5 }
        else if (s == ether())       { 6 }
        else { abort error::invalid_argument(0) } // E_INVALID_TYPE
    }

    public inline fun affinity_name_index(s: String): u8 {
             if (s == solid())       { 0 }
        else if (s == swift())       { 1 }
        else if (s == harmonic())    { 2 }
        else if (s == psyche())      { 3 }
        else if (s == adaptive())    { 4 }
        else if (s == disruptive())  { 5 }
        else { abort error::invalid_argument(0) } // E_INVALID_TYPE
    }

    // public inline fun attribute(s: String): u8 {
    public fun attribute(s: String): u8 {
             if (s == string::utf8(b"MAX_ENERGY"))              { 0 }
        else if (s == string::utf8(b"ENERGY_RECHARGE_RATE"))    { 1 }
        else if (s == string::utf8(b"ENERGY_EFFICIENCY"))       { 2 }
        else if (s == string::utf8(b"MAX_HUNGER"))              { 3 }
        else if (s == string::utf8(b"HUNGER_RESISTANCE"))       { 4 }
        else if (s == string::utf8(b"MAX_THIRST"))              { 5 }
        else if (s == string::utf8(b"THIRST_RESISTANCE"))       { 6 }
        else if (s == string::utf8(b"MAX_HAPPINESS"))           { 7 }
        else if (s == string::utf8(b"MAX_JOY"))                 { 8 }
        else if (s == string::utf8(b"JOY_RESPONSE"))            { 9 }
        else if (s == string::utf8(b"JOY_ABILITY"))             { 10 }
        else if (s == string::utf8(b"MAX_IMMUNITY"))            { 11 }
        else if (s == string::utf8(b"IMMUNITY_THRESHOLD"))      { 12 }
        else if (s == string::utf8(b"IMMUNITY_PERSISTENCE"))    { 13 }
        else if (s == string::utf8(b"MAX_INTELLIGENCE"))        { 14 }
        else if (s == string::utf8(b"INTELLIGENCE_POTENTIAL"))  { 15 }
        else { abort error::invalid_argument(0) } // E_INVALID_TYPE
    }
}

module mojo_monsters::enums_tests {
    #[test_only] use std::vector;

    #[test_only] use std::string::{Self};
    #[test_only] use mojo_monsters::elements::{Fire, Earth, Water, Air, Crystal, Electricity, Ether};
    #[test_only] use mojo_monsters::affinity::{Solid, Swift, Harmonic, Psyche, Adaptive, Disruptive};
    #[test_only] use mojo_monsters::enums::{element_name, affinity_name, element_name_index, element, affinity, affinity_name_index, get_element_names, get_affinity_names};
    #[test_only] use mojo_monsters::enums::{fire, earth, water, air, crystal, electricity, ether, solid, swift, harmonic, psyche, adaptive, disruptive, attribute};

    // Elements
    // ---------------------------------------------------------------
    #[test_only] const FIRE: vector<u8> = b"FIRE";
    #[test_only] const EARTH: vector<u8> = b"EARTH";
    #[test_only] const WATER: vector<u8> = b"WATER";
    #[test_only] const AIR: vector<u8> = b"AIR";
    #[test_only] const CRYSTAL: vector<u8> = b"CRYSTAL";
    #[test_only] const ELECTRICITY: vector<u8> = b"ELECTRICITY";
    #[test_only] const ETHER: vector<u8> = b"ETHER";

    // Affinities
    // ---------------------------------------------------------------
    #[test_only] const SOLID: vector<u8> = b"SOLID";
    #[test_only] const SWIFT: vector<u8> = b"SWIFT";
    #[test_only] const HARMONIC: vector<u8> = b"HARMONIC";
    #[test_only] const PSYCHE: vector<u8> = b"PSYCHE";
    #[test_only] const ADAPTIVE: vector<u8> = b"ADAPTIVE";
    #[test_only] const DISRUPTIVE: vector<u8> = b"DISRUPTIVE";

    // Attributes (element + affinity)
    // ---------------------------------------------------------------
    #[test_only] const MAX_ENERGY: vector<u8> = b"MAX_ENERGY";
    #[test_only] const ENERGY_RECHARGE_RATE: vector<u8> = b"ENERGY_RECHARGE_RATE";
    #[test_only] const ENERGY_EFFICIENCY: vector<u8> = b"ENERGY_EFFICIENCY";
    #[test_only] const MAX_HUNGER: vector<u8> = b"MAX_HUNGER";
    #[test_only] const HUNGER_RESISTANCE: vector<u8> = b"HUNGER_RESISTANCE";
    #[test_only] const MAX_THIRST: vector<u8> = b"MAX_THIRST";
    #[test_only] const THIRST_RESISTANCE: vector<u8> = b"THIRST_RESISTANCE";
    #[test_only] const MAX_HAPPINESS: vector<u8> = b"MAX_HAPPINESS";
    #[test_only] const MAX_JOY: vector<u8> = b"MAX_JOY";
    #[test_only] const JOY_RESPONSE: vector<u8> = b"JOY_RESPONSE";
    #[test_only] const JOY_ABILITY: vector<u8> = b"JOY_ABILITY";
    #[test_only] const MAX_IMMUNITY: vector<u8> = b"MAX_IMMUNITY";
    #[test_only] const IMMUNITY_THRESHOLD: vector<u8> = b"IMMUNITY_THRESHOLD";
    #[test_only] const IMMUNITY_PERSISTENCE: vector<u8> = b"IMMUNITY_PERSISTENCE";
    #[test_only] const MAX_INTELLIGENCE: vector<u8> = b"MAX_INTELLIGENCE";
    #[test_only] const INTELLIGENCE_POTENTIAL: vector<u8> = b"INTELLIGENCE_POTENTIAL";

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
            assert!(element_name_index(*e) == (i as u8), 0);
            if (i < vector::length(&get_affinity_names())) {
                let a = vector::borrow(&get_affinity_names(), i);
                assert!(affinity_name_index(*a) == (i as u8), 0);
            };
        });

        assert!(fire() == string::utf8(FIRE), 0);
        assert!(earth() == string::utf8(EARTH), 1);
        assert!(water() == string::utf8(WATER), 2);
        assert!(air() == string::utf8(AIR), 3);
        assert!(crystal() == string::utf8(CRYSTAL), 4);
        assert!(electricity() == string::utf8(ELECTRICITY), 5);
        assert!(ether() == string::utf8(ETHER), 6);
        assert!(solid() == string::utf8(SOLID), 7);
        assert!(swift() == string::utf8(SWIFT), 8);
        assert!(harmonic() == string::utf8(HARMONIC), 9);
        assert!(psyche() == string::utf8(PSYCHE), 10);
        assert!(adaptive() == string::utf8(ADAPTIVE), 11);
        assert!(disruptive() == string::utf8(DISRUPTIVE), 12);

        assert!(attribute(string::utf8(MAX_ENERGY)) == 0, 0);
        assert!(attribute(string::utf8(ENERGY_RECHARGE_RATE)) == 1, 1);
        assert!(attribute(string::utf8(ENERGY_EFFICIENCY)) == 2, 2);
        assert!(attribute(string::utf8(MAX_HUNGER)) == 3, 3);
        assert!(attribute(string::utf8(HUNGER_RESISTANCE)) == 4, 4);
        assert!(attribute(string::utf8(MAX_THIRST)) == 5, 5);
        assert!(attribute(string::utf8(THIRST_RESISTANCE)) == 6, 6);
        assert!(attribute(string::utf8(MAX_HAPPINESS)) == 7, 7);
        assert!(attribute(string::utf8(MAX_JOY)) == 8, 8);
        assert!(attribute(string::utf8(JOY_RESPONSE)) == 9, 9);
        assert!(attribute(string::utf8(JOY_ABILITY)) == 10, 10);
        assert!(attribute(string::utf8(MAX_IMMUNITY)) == 11, 11);
        assert!(attribute(string::utf8(IMMUNITY_THRESHOLD)) == 12, 12);
        assert!(attribute(string::utf8(IMMUNITY_PERSISTENCE)) == 13, 13);
        assert!(attribute(string::utf8(MAX_INTELLIGENCE)) == 14, 14);
        assert!(attribute(string::utf8(INTELLIGENCE_POTENTIAL)) == 15, 15);
    }
}