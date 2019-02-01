use "logics/constructors.sig";
use "logics/variables.sig";

signature Literals =
   sig
      structure Constructors: Constructors
      structure Variables: Variables

      type MultiLiteral
      type T

      val get_val:      T -> T
      val eq:           T * T -> bool
      val multi_eq:     MultiLiteral * MultiLiteral -> bool

      val equate:       T * T -> bool
      val multi_equate: MultiLiteral * MultiLiteral -> bool

      val vmap:         (Variables.T -> Variables.T) -> T -> T
      val multi_vmap:   (Variables.T -> Variables.T) -> MultiLiteral -> MultiLiteral
  end;
