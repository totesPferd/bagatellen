use "logics/literals/in.sig";
use "logics/variables.sig";

signature Literals =
   sig
      structure LiteralsIn: LiteralsIn
      structure Variables: Variables
      structure Construction:
         sig
            type T
         end

      val equate:       LiteralsIn.PT.BaseType.T * LiteralsIn.PT.BaseType.T -> bool
      val multi_equate: LiteralsIn.PT.ContainerType.T * LiteralsIn.PT.ContainerType.T -> bool

  end;
