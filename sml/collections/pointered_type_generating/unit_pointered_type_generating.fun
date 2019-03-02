use "general/eqs.sig";
use "collections/unit_pointered_type_generating.sig";
use "collections/unit_polymorphic_container_type.sig";

functor UnitPointeredTypeGenerating(X:
   sig
      structure BaseType: Eqs
      structure PolymorphicContainerType: UnitPolymorphicContainerType
   end ): UnitPointeredTypeGenerating =
   struct
      structure PolymorphicContainerType =  X.PolymorphicContainerType
      structure PointeredType =
         struct
            structure BaseType =  X.BaseType
            structure ContainerType =
               struct
                  type T =  BaseType.T PolymorphicContainerType.T
                  fun eq(Option.NONE, Option.NONE) =  true
                  |   eq(Option.NONE, Option.SOME _) =  false
                  |   eq(Option.SOME _, Option.NONE) =  false
                  |   eq(Option.SOME x, Option.SOME y) =  BaseType.eq(x, y)
               end
            structure PointerType =
               struct
                  type T =  unit
               end
      
            val empty         =  Option.NONE
            val is_empty      =  not o Option.isSome
            fun select (_, x) =  x

         end

         fun singleton (_, x) =  Option.SOME x

   end;
