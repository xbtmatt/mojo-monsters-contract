module mojo_monsters::mojo_errors {
    use std::error;

    /// You are not authorized to perform this action.
    const E_NOT_AUTHORIZED: u64 = 0;
    /// You have provided an invalid type.
    const E_INVALID_TYPE: u64 = 1;
    /// The address provided is not a biomass object.
    const E_NOT_A_BIOMASS: u64 = 2;

    public fun invalid_type(): u64 {
        error::invalid_argument(E_INVALID_TYPE)
    }

    public fun not_authorized(): u64 {
        error::permission_denied(E_NOT_AUTHORIZED)
    }

    public fun invalid_biomass(): u64 {
        error::invalid_argument(E_NOT_A_BIOMASS)
    }
}
