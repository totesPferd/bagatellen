use "logics/constructors.sig";
use "logics/variables.sig";

signature Literals =
   sig
      structure Constructors: Constructors
      structure Variables: Variables

      type T

      val get_val:      T -> T
      val eq:           T * T -> bool

      val equate:       T * T -> bool

      val vmap:         (Variables.T -> Variables.T) -> T -> T
  end;
