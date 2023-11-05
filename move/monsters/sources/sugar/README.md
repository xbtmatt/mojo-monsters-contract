### Purpose
There are no enums in Move, and we have lots of types that need to be easy to index/use without having to clutter the code with `type_of<T>()`.
We also need to circumvent the circular dependencies here, since Move won't let us use the types and use helper functions for the types at the same time, if the helper functions rely
on external Move modules that also reference the implementation of teh types. 

We can use custom inline functions to convert them to strings at runtime with this.
