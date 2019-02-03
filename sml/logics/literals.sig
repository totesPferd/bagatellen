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
      structure Multi:
         sig
            type T
            val equate:       T * T -> bool
            val eq:           T * T -> bool
            val is_empty:     T -> bool
         end
      structure Out:
         sig
            type T
            val equate:       T * T -> bool
            val eq:           T * T -> bool
         end

      val resolve:    Out.T * Multi.T -> Multi.T -> Multi.T

      val transition: (Out.T * 'b -> 'b Option.option) -> Multi.T -> 'b -> 'b

  end;
