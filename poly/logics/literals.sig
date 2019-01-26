use "logics/constructors.sig";
use "logics/variables.sig";

signature Literals =
   sig
      structure Constructors: Constructors
      structure Variables: Variables

      type MultiLiteral
      datatype Literal =  Constructor of Constructors.Constructor * MultiLiteral |  Variable of Literal Variables.Variable

      val eq:           Literal * Literal -> bool

      val equate:       Literal * Literal -> unit
      val multi_equate: MultiLiteral * MultiLiteral -> unit
   end;
