use "logics/constructors.sig";
use "logics/variables.sig";

signature Literals =
   sig
      structure Constructors: Constructors

      type MultiLiteral
      type T
      type V

      val get_val:      T -> T
      val eq:           T * T -> bool
      val multi_eq:     MultiLiteral * MultiLiteral -> bool
      val veq:          V * V -> bool

      val equate:       T * T -> bool
      val multi_equate: MultiLiteral * MultiLiteral -> bool

      val vcopy:        V -> V

      val pmap:         (V -> V Option.option) -> T -> T Option.option
      val multi_pmap:   (V -> V Option.option) -> MultiLiteral -> MultiLiteral Option.option
  end;
