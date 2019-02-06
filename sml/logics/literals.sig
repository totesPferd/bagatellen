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
            structure Variables:  Variables
            type T
            val equate:       T * T -> bool
            val eq:           T * T -> bool
            val empty:        unit -> T
            val is_empty:     T -> bool
            val vmap:         (Variables.T -> Variables.T) -> T -> T
         end
      structure Single:
         sig
            structure Variables:  Variables
            type T
            val equate:       T * T -> bool
            val eq:           T * T -> bool
            val vmap:         (Variables.T -> Variables.T) -> T -> T
         end
      structure PointerType:
         sig
            type T
         end
      sharing Multi.Variables = Variables
      sharing Single.Variables = Variables

      val select:     PointerType.T * Multi.T -> Single.T

      val fe:         Single.T -> Multi.T
      val fop:        (Single.T -> Multi.T) -> Multi.T -> Multi.T
      val is_in:      Single.T * Multi.T -> bool

      (* auf der Abschussliste: *)
      val replace:    Single.T * Multi.T -> Multi.T -> Multi.T
      val transition: (Single.T * 'b -> 'b Option.option) -> Multi.T -> 'b -> 'b

  end;
