use "collections/occurences.sig";
use "collections/pointered_type_extended.sig";
use "general/map.sig";
use "logics/constructors.sig";
use "logics/variables.sig";
use "logics/variable_structure.sig";

signature Literals =
   sig
      structure Constructors: Constructors
      structure Occurences: Occurences
      structure PointeredTypeExtended: PointeredTypeExtended
      structure Variables: Variables
      structure VariableStructure: VariableStructure
      structure Single:
         sig
            structure Variables: Variables
            type T
            val eq: T * T -> bool
            val equate:         T * T -> bool
            val get_occurences: T -> Occurences.occurences
            val vmap:           VariableStructure.Map.Map.T -> T -> T
         end
      structure Multi:
         sig
            structure Variables: Variables
            type T
            val eq: T * T -> bool
            val equate:         T * T -> bool
            val get_occurences: T -> Occurences.occurences
            val empty:          T
            val is_empty:       T -> bool
            val vmap:           VariableStructure.Map.Map.T -> T -> T
            val subeq:          T * T -> bool
         end
      structure PointerType: Type
      sharing PointeredTypeExtended.BaseType = Single
      sharing PointeredTypeExtended.PointerType = PointerType
      sharing PointeredTypeExtended.ContainerType = Multi
      sharing PointeredTypeExtended.BaseStructure = Single
      sharing VariableStructure.BaseType = Single
      sharing Single.Variables = Variables
      sharing Multi.Variables = Variables
      sharing VariableStructure.Variables = Variables

      val get_val:    Variables.Base.T -> Variables.Base.T

      val select:     PointerType.T * Multi.T -> Single.T Option.option

      val is_in:      Single.T * Multi.T -> bool

      val transition: (Single.T * 'b -> 'b Option.option) -> Multi.T -> 'b -> 'b

   end;
