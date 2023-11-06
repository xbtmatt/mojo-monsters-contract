module mojo_monsters::enums {
    use std::string::{Self, String};
    use aptos_std::type_info::{type_of};
    use mojo_monsters::element::{None, Fire, Earth, Water, Air, Crystal, Electricity, Ether};
    use mojo_monsters::affinity::{Balanced, Solid, Swift, Harmonic, Psyche, Adaptive, Disruptive};
    use mojo_monsters::type_discriminators;
    use mojo_monsters::mojo_errors;
    use std::vector;

    public inline fun get_element_names(): vector<String> {
        vector<String> [ none(), fire(), earth(), water(), air(), crystal(), electricity(), ether() ]
    }

    public inline fun get_affinity_names(): vector<String> {
        vector<String>[ balanced(), solid(), swift(), harmonic(), psyche(), adaptive(), disruptive() ]
    }

    public inline fun get_attribute_names(): vector<String> {
        vector::map(vector<vector<u8>> [ b"MAX_ENERGY", b"ENERGY_RECHARGE_RATE", b"ENERGY_EFFICIENCY", b"MAX_HUNGER", b"HUNGER_RESISTANCE", b"MAX_JOY", b"JOY_RESPONSE", b"JOY_ABILITY", b"MAX_IMMUNITY", b"IMMUNITY_THRESHOLD", b"IMMUNITY_PERSISTENCE", b"MAX_INTELLIGENCE", b"INHERENT_INTELLIGENCE", b"INTELLIGENCE_POTENTIAL" ], |x| { string::utf8(x) })
    }

    public fun none(): String { string::utf8(b"NONE") }
    public fun fire(): String { string::utf8(b"FIRE") }
    public fun earth(): String { string::utf8(b"EARTH") }
    public fun water(): String { string::utf8(b"WATER") }
    public fun air(): String { string::utf8(b"AIR") }
    public fun crystal(): String { string::utf8(b"CRYSTAL") }
    public fun electricity(): String { string::utf8(b"ELECTRICITY") }
    public fun ether(): String { string::utf8(b"ETHER") }

    public fun balanced(): String { string::utf8(b"BALANCED") }
    public fun solid(): String { string::utf8(b"SOLID") }
    public fun swift(): String { string::utf8(b"SWIFT") }
    public fun harmonic(): String { string::utf8(b"HARMONIC") }
    public fun psyche(): String { string::utf8(b"PSYCHE") }
    public fun adaptive(): String { string::utf8(b"ADAPTIVE") }
    public fun disruptive(): String { string::utf8(b"DISRUPTIVE") }

    public fun name<T>(): String {
        // elements
        if (type_discriminators::is_an_element<T>()) { element_name<T>() }
        else if ( type_discriminators::is_an_affinity<T>() ) { affinity_name<T>() }
        else { abort mojo_errors::invalid_type() }
    }
    
    public fun element_name<T>(): String {
        // elements
             if (type_of<T>() == type_of<None>())        { none() }
        else if (type_of<T>() == type_of<Fire>())        { fire() }
        else if (type_of<T>() == type_of<Earth>())       { earth() }
        else if (type_of<T>() == type_of<Water>())       { water() }
        else if (type_of<T>() == type_of<Air>())         { air() }
        else if (type_of<T>() == type_of<Crystal>())     { crystal() }
        else if (type_of<T>() == type_of<Electricity>()) { electricity() }
        else if (type_of<T>() == type_of<Ether>())       { ether() }
        else { abort mojo_errors::invalid_type() }
    }

    public fun affinity_name<T>(): String {
             if (type_of<T>() == type_of<Balanced>())    { balanced() }
        else if (type_of<T>() == type_of<Solid>())       { solid() }
        else if (type_of<T>() == type_of<Swift>())       { swift() }
        else if (type_of<T>() == type_of<Harmonic>())    { harmonic() }
        else if (type_of<T>() == type_of<Psyche>())      { psyche() }
        else if (type_of<T>() == type_of<Adaptive>())    { adaptive() }
        else if (type_of<T>() == type_of<Disruptive>())  { disruptive() }
        else { abort mojo_errors::invalid_type() }
    }

    // public inline fun element<T>(): u8 {
    public fun element<T>(): u8 {
             if (type_of<T>() == type_of<None>())        { 0 }
        else if (type_of<T>() == type_of<Fire>())        { 1 }
        else if (type_of<T>() == type_of<Earth>())       { 2 }
        else if (type_of<T>() == type_of<Water>())       { 3 }
        else if (type_of<T>() == type_of<Air>())         { 4 }
        else if (type_of<T>() == type_of<Crystal>())     { 5 }
        else if (type_of<T>() == type_of<Electricity>()) { 6 }
        else if (type_of<T>() == type_of<Ether>())       { 7 }
        else { abort mojo_errors::invalid_type() }
    }
    
    // public inline fun affinity<T>(): u8 {
    public fun affinity<T>(): u8 {
             if (type_of<T>() == type_of<Balanced>())    { 0 }
        else if (type_of<T>() == type_of<Solid>())       { 1 }
        else if (type_of<T>() == type_of<Swift>())       { 2 }
        else if (type_of<T>() == type_of<Harmonic>())    { 3 }
        else if (type_of<T>() == type_of<Psyche>())      { 4 }
        else if (type_of<T>() == type_of<Adaptive>())    { 5 }
        else if (type_of<T>() == type_of<Disruptive>())  { 6 }
        else { abort mojo_errors::invalid_type() }
    }

    // public inline fun element_name_index(s: String): u8 {
    public fun element_name_index(s: String): u8 {
             if (s == none())        { 0 }
        else if (s == fire())        { 1 }
        else if (s == earth())       { 2 }
        else if (s == water())       { 3 }
        else if (s == air())         { 4 }
        else if (s == crystal())     { 5 }
        else if (s == electricity()) { 6 }
        else if (s == ether())       { 7 }
        else { abort mojo_errors::invalid_type() }
    }

    public fun affinity_name_index(s: String): u8 {
             if (s == balanced())    { 0 }
        else if (s == solid())       { 1 }
        else if (s == swift())       { 2 }
        else if (s == harmonic())    { 3 }
        else if (s == psyche())      { 4 }
        else if (s == adaptive())    { 5 }
        else if (s == disruptive())  { 6 }
        else { abort mojo_errors::invalid_type() }
    }

    // public inline fun attribute(s: String): u8 {
    public fun attribute(s: String): u8 {
             if (s == string::utf8(b"MAX_ENERGY"))              { 0 }
        else if (s == string::utf8(b"ENERGY_RECHARGE_RATE"))    { 1 }
        else if (s == string::utf8(b"ENERGY_EFFICIENCY"))       { 2 }
        else if (s == string::utf8(b"MAX_HUNGER"))              { 3 }
        else if (s == string::utf8(b"HUNGER_RESISTANCE"))       { 4 }
        else if (s == string::utf8(b"MAX_JOY"))                 { 5 }
        else if (s == string::utf8(b"JOY_RESPONSE"))            { 6 }
        else if (s == string::utf8(b"JOY_ABILITY"))             { 7 }
        else if (s == string::utf8(b"MAX_IMMUNITY"))            { 8 }
        else if (s == string::utf8(b"IMMUNITY_THRESHOLD"))      { 9 }
        else if (s == string::utf8(b"IMMUNITY_PERSISTENCE"))    { 10 }
        else if (s == string::utf8(b"MAX_INTELLIGENCE"))        { 11 }
        else if (s == string::utf8(b"INHERENT_INTELLIGENCE"))   { 12 }
        else if (s == string::utf8(b"INTELLIGENCE_POTENTIAL"))  { 13 }
        else { abort mojo_errors::invalid_type() }
    }
}

module mojo_monsters::enums_tests {
    #[test_only] use std::vector;

    #[test_only] use std::string::{Self};
    #[test_only] use mojo_monsters::element::{None, Fire, Earth, Water, Air, Crystal, Electricity, Ether};
    #[test_only] use mojo_monsters::affinity::{Balanced, Solid, Swift, Harmonic, Psyche, Adaptive, Disruptive};
    #[test_only] use mojo_monsters::enums::{element_name, affinity_name, element_name_index, element, affinity, affinity_name_index, get_element_names, get_affinity_names, get_attribute_names};
    #[test_only] use mojo_monsters::enums::{none, fire, earth, water, air, crystal, electricity, ether, balanced, solid, swift, harmonic, psyche, adaptive, disruptive, attribute};

    // Elements
    // ---------------------------------------------------------------
    #[test_only] const NONE: vector<u8> = b"NONE";
    #[test_only] const FIRE: vector<u8> = b"FIRE";
    #[test_only] const EARTH: vector<u8> = b"EARTH";
    #[test_only] const WATER: vector<u8> = b"WATER";
    #[test_only] const AIR: vector<u8> = b"AIR";
    #[test_only] const CRYSTAL: vector<u8> = b"CRYSTAL";
    #[test_only] const ELECTRICITY: vector<u8> = b"ELECTRICITY";
    #[test_only] const ETHER: vector<u8> = b"ETHER";

    // Affinities
    // ---------------------------------------------------------------
    #[test_only] const BALANCED: vector<u8> = b"BALANCED";
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
    #[test_only] const MAX_JOY: vector<u8> = b"MAX_JOY";
    #[test_only] const JOY_RESPONSE: vector<u8> = b"JOY_RESPONSE";
    #[test_only] const JOY_ABILITY: vector<u8> = b"JOY_ABILITY";
    #[test_only] const MAX_IMMUNITY: vector<u8> = b"MAX_IMMUNITY";
    #[test_only] const IMMUNITY_THRESHOLD: vector<u8> = b"IMMUNITY_THRESHOLD";
    #[test_only] const IMMUNITY_PERSISTENCE: vector<u8> = b"IMMUNITY_PERSISTENCE";
    #[test_only] const MAX_INTELLIGENCE: vector<u8> = b"MAX_INTELLIGENCE";
    #[test_only] const INHERENT_INTELLIGENCE: vector<u8> = b"INHERENT_INTELLIGENCE";
    #[test_only] const INTELLIGENCE_POTENTIAL: vector<u8> = b"INTELLIGENCE_POTENTIAL";

    #[test]
    fun test_enum_indices() {
        assert!(element_name<None>() == none(), 0);
        assert!(element_name<Fire>() == fire(), 0);
        assert!(element_name<Earth>() == earth(), 0);
        assert!(element_name<Water>() == water(), 0);
        assert!(element_name<Air>() == air(), 0);
        assert!(element_name<Crystal>() == crystal(), 0);
        assert!(element_name<Electricity>() == electricity(), 0);
        assert!(element_name<Ether>() == ether(), 0);

        assert!(affinity_name<Balanced>() == balanced(), 0);
        assert!(affinity_name<Solid>() == solid(), 0);
        assert!(affinity_name<Swift>() == swift(), 0);
        assert!(affinity_name<Harmonic>() == harmonic(), 0);
        assert!(affinity_name<Psyche>() == psyche(), 0);
        assert!(affinity_name<Adaptive>() == adaptive(), 0);
        assert!(affinity_name<Disruptive>() == disruptive(), 0);

        assert!(element_name_index(element_name<None>()) == element<None>(), 0);
        assert!(element_name_index(element_name<Fire>()) == element<Fire>(), 0);
        assert!(element_name_index(element_name<Earth>()) == element<Earth>(), 0);
        assert!(element_name_index(element_name<Water>()) == element<Water>(), 0);
        assert!(element_name_index(element_name<Air>()) == element<Air>(), 0);
        assert!(element_name_index(element_name<Crystal>()) == element<Crystal>(), 0);
        assert!(element_name_index(element_name<Electricity>()) == element<Electricity>(), 0);
        assert!(element_name_index(element_name<Ether>()) == element<Ether>(), 0);

        assert!(affinity_name_index(affinity_name<Balanced>()) == affinity<Balanced>(), 0);
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

        vector::enumerate_ref(&get_attribute_names(), |i, e| {
            assert!(attribute(*e) == (i as u8), 0);
        });

        assert!(none() == string::utf8(NONE), 0);
        assert!(fire() == string::utf8(FIRE), 1);
        assert!(earth() == string::utf8(EARTH), 2);
        assert!(water() == string::utf8(WATER), 3);
        assert!(air() == string::utf8(AIR), 4);
        assert!(crystal() == string::utf8(CRYSTAL), 5);
        assert!(electricity() == string::utf8(ELECTRICITY), 6);
        assert!(ether() == string::utf8(ETHER), 7);

        assert!(balanced() == string::utf8(BALANCED), 8);
        assert!(solid() == string::utf8(SOLID), 9);
        assert!(swift() == string::utf8(SWIFT), 10);
        assert!(harmonic() == string::utf8(HARMONIC), 11);
        assert!(psyche() == string::utf8(PSYCHE), 12);
        assert!(adaptive() == string::utf8(ADAPTIVE), 13);
        assert!(disruptive() == string::utf8(DISRUPTIVE), 14);

        assert!(attribute(string::utf8(MAX_ENERGY)) == 0, 0);
        assert!(attribute(string::utf8(ENERGY_RECHARGE_RATE)) == 1, 1);
        assert!(attribute(string::utf8(ENERGY_EFFICIENCY)) == 2, 2);
        assert!(attribute(string::utf8(MAX_HUNGER)) == 3, 3);
        assert!(attribute(string::utf8(HUNGER_RESISTANCE)) == 4, 4);
        assert!(attribute(string::utf8(MAX_JOY)) == 5, 5);
        assert!(attribute(string::utf8(JOY_RESPONSE)) == 6, 6);
        assert!(attribute(string::utf8(JOY_ABILITY)) == 7, 7);
        assert!(attribute(string::utf8(MAX_IMMUNITY)) == 8, 8);
        assert!(attribute(string::utf8(IMMUNITY_THRESHOLD)) == 9, 9);
        assert!(attribute(string::utf8(IMMUNITY_PERSISTENCE)) == 10, 10);
        assert!(attribute(string::utf8(MAX_INTELLIGENCE)) == 11, 11);
        assert!(attribute(string::utf8(INHERENT_INTELLIGENCE)) == 12, 12);
        assert!(attribute(string::utf8(INTELLIGENCE_POTENTIAL)) == 13, 13);
    }
}