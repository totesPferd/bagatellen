use "logics/constructors.sig";
use "logics/variables.sig";

signature Literals =
   sig
      structure Constructors: Constructors
      structure Variables: Variables

      type MultiLiteral
      type L
      type T

      val get_val:      T -> T
      val eq:           T * T -> bool
      val multi_eq:     MultiLiteral * MultiLiteral -> bool

      val equate:       T * T -> bool
      val multi_equate: MultiLiteral * MultiLiteral -> bool


      val pmap:         (Variables.Variable -> Variables.Variable Option.option) -> T -> T Option.option
      val multi_pmap:   (Variables.Variable -> Variables.Variable Option.option) -> MultiLiteral -> MultiLiteral Option.option
  end;
