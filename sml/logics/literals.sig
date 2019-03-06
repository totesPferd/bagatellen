use "collections/occurences.sig";
use "collections/pointered_type_extended.sig";
use "logics/constructors.sig";
use "logics/variables.sig";

signature Literals =
   sig
      structure Constructors: Constructors
      structure PointeredTypeExtended: PointeredTypeExtended
      structure Variables: Variables
      structure Single:
         sig
            structure Variables: Variables
            type T
            val eq: T * T -> bool
            val equate:         T * T -> bool
            val traverse:       (Constructors.T * 'a -> 'b) * (Variables.T -> 'b) * ('b * 'a -> 'a Option.option) * 'a -> T -> 'b
            val variable:       Variables.T -> T
            val vmap:           (Variables.T -> Variables.T) -> T -> T
         end
      structure Multi:
         sig
            structure Variables: Variables
            type T
            val eq: T * T -> bool
            val equate:         T * T -> bool
            val traverse:       (Constructors.T * 'a -> 'b) * (Variables.T -> 'b) * ('b * 'a -> 'a Option.option) * 'a -> T -> 'a
            val empty:          T
            val is_empty:       T -> bool
            val vmap:           (Variables.T -> Variables.T) -> T -> T
            val subeq:          T * T -> bool
         end
      structure PointerType: Type
      sharing PointeredTypeExtended.BaseType =  Single
      sharing PointeredTypeExtended.PointerType =  PointerType
      sharing PointeredTypeExtended.ContainerType =  Multi
      sharing Variables.Base =  Single
      sharing Single.Variables =  Variables
      sharing Multi.Variables =  Variables

      val get_val: Single.T -> Single.T

      val select:     PointerType.T * Multi.T -> Single.T Option.option

      val is_in:      Single.T * Multi.T -> bool

      val construct:  Constructors.T * Multi.T -> Single.T
      val transition: (Single.T * 'b -> 'b Option.option) -> Multi.T -> 'b -> 'b

   end;
