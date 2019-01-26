use "logics/constructors.sig";
use "logics/variables.sig";

signature Literals =
   sig
      structure Constructors: Constructors
      structure Variables: Variables

      type MultiLiteral
      type Literal

      val get_val:      Literal -> Literal
      val eq:           Literal * Literal -> bool
      val multi_eq:     MultiLiteral * MultiLiteral -> bool

      val equate:       Literal * Literal -> bool
      val multi_equate: MultiLiteral * MultiLiteral -> bool
   end;
