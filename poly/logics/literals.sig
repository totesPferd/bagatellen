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

      val map:          (T Variables.Variable -> T Variables.Variable) -> T -> T
      val multi_map:    (T Variables.Variable -> T Variables.Variable) -> MultiLiteral -> MultiLiteral
  end;
