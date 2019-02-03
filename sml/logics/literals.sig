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
         end
      structure Out:
         sig
            type T
            val equate:       T * T -> bool
         end

  end;
