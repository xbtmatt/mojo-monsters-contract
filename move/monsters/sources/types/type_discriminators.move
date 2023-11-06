module mojo_monsters::type_discriminators {
    use aptos_framework::type_info::{type_of};
    use mojo_monsters::element::{Fire, Earth, Water, Air, Crystal, Electricity, Ether};
    use mojo_monsters::affinity::{Balanced, Solid, Swift, Harmonic, Psyche, Adaptive, Disruptive};
    use mojo_monsters::mojo_errors;

    public fun assert_is_element<Element>() {
        assert!(is_an_element<Element>(), mojo_errors::invalid_type());
    }

    public fun assert_is_affinity<Affinity>() {
        assert!(is_an_affinity<Affinity>(), mojo_errors::invalid_type());
    }

    public inline fun is_an_element<Element>(): bool {
        // elements
        (type_of<Element>() == type_of<Fire>())        ||
        (type_of<Element>() == type_of<Earth>())       ||
        (type_of<Element>() == type_of<Water>())       ||
        (type_of<Element>() == type_of<Air>())         ||
        (type_of<Element>() == type_of<Crystal>())     ||
        (type_of<Element>() == type_of<Electricity>()) ||
        (type_of<Element>() == type_of<Ether>())
    }

    public inline fun is_an_affinity<Affinity>(): bool {
        // affinities
        (type_of<Affinity>() == type_of<Balanced>())    ||
        (type_of<Affinity>() == type_of<Solid>())       ||
        (type_of<Affinity>() == type_of<Swift>())       ||
        (type_of<Affinity>() == type_of<Harmonic>())    ||
        (type_of<Affinity>() == type_of<Psyche>())      ||
        (type_of<Affinity>() == type_of<Adaptive>())    ||
        (type_of<Affinity>() == type_of<Disruptive>())
    }
}