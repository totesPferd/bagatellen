use "logics/constructors.sig";

signature Literals =
   sig
      structure Constructors: Constructors

      type MultiLiteral
      type L
      type T

      type Variable
      val veq:          Variable * Variable -> bool
      val vcopy:        Variable -> Variable

      val get_val:      T -> T
      val eq:           T * T -> bool
      val multi_eq:     MultiLiteral * MultiLiteral -> bool

      val equate:       T * T -> bool
      val multi_equate: MultiLiteral * MultiLiteral -> bool


      val pmap:         (Variable -> Variable Option.option) -> T -> T Option.option
      val multi_pmap:   (Variable -> Variable Option.option) -> MultiLiteral -> MultiLiteral Option.option
  end;
