use "collections/occurences.sig";
use "collections/pointered_type.sig";
use "logics/constructors.sig";
use "logics/variables.sig";

signature Literals =
   sig
      structure Constructors: Constructors
      structure Occurences: Occurences
      structure PointeredType: PointeredType
      structure Variables: Variables
      sharing Occurences.DictSet.Eqs = Variables
      structure Multi:
         sig
            structure Variables:  Variables
            type T
            val equate:         T * T -> bool
            val eq:             T * T -> bool
            val empty:          T
            val is_empty:       T -> bool
            val subeq:          T * T -> bool
            val vmap:           (Variables.T -> Variables.T) -> T -> T
            val get_occurences: T -> Occurences.occurences
            val traverse:       (Constructors.T * 'm -> 's) * (Variables.T -> 's) * ('s * 'm -> 'm Option.option) * 'm -> T -> 'm
        end
      structure Single:
         sig
            structure Variables:  Variables
            type T
            val variable:       Variables.T -> T
            val equate:         T * T -> bool
            val eq:             T * T -> bool
            val vmap:           (Variables.T -> Variables.T) -> T -> T
            val get_occurences: T -> Occurences.occurences
            val traverse:       (Constructors.T * 'm -> 's) * (Variables.T -> 's) * ('s * 'm -> 'm Option.option) * 'm -> T -> 's
         end
      structure PointerType:
         sig
            type T
         end
      sharing Multi.Variables = Variables
      sharing Single.Variables = Variables
      sharing Variables.Base =  Single

      val select:     PointerType.T * Multi.T -> Single.T Option.option

      val fe:         Single.T -> Multi.T
      val fop:        (Single.T -> Multi.T) -> Multi.T -> Multi.T
      val is_in:      Single.T * Multi.T -> bool

      val construct:  Constructors.T * Multi.T -> Single.T
      val transition: (Single.T * 'b -> 'b Option.option) -> Multi.T -> 'b -> 'b

  end;
