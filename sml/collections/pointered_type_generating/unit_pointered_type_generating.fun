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
      structure PointeredTypeExtended =
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

            fun all P Option.NONE =  true
              | all P (Option.SOME x) = P x
      
            exception ZipLengthsDoesNotAgree
            fun all_zip P (Option.NONE, Option.NONE) =  true
              | all_zip P (Option.SOME x_1, Option.SOME x_2) =  P(x_1, x_2)
              | all_zip P (Option.NONE, Option.SOME x_2) =  raise ZipLengthsDoesNotAgree
              | all_zip P (Option.SOME x_1, Option.NONE) =  raise ZipLengthsDoesNotAgree
      
            fun filter P Option.NONE =  Option.NONE
            |   filter P (Option.SOME x)
               =  if P x
                  then Option.SOME x
                  else Option.NONE
      
            fun transition phi Option.NONE b =  b
              | transition phi (Option.SOME x) b
              = case(phi (x, b)) of
                   Option.NONE =>  b
                |  Option.SOME c => c
      
            val fe =  Option.SOME

            fun is_in (x, c)
              = Option.isSome (Option.map (fn (y) => BaseType.eq(x, y)) c)
      
            fun subeq (c_1, c_2)
              = case(c_1) of
                   Option.NONE => true
                |  Option.SOME x => is_in (x, c_2)
      
         end

         fun singleton (_, x) =  Option.SOME x

   end;
