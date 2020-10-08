use "collections/all_zip.sig";
use "collections/unit_pointered_type_generating.sig";
use "collections/unit_polymorphic_container_type.sig";
use "general/eqs.sig";
use "general/type_map.sig";
use "general/type_binary_relation.sig";

functor UnitPointeredTypeGenerating(X:
   sig
      structure BaseType: Eqs
      structure BaseStructureMap: TypeMap
      structure BinaryRelation: TypeBinaryRelation
      structure PolymorphicContainerType: UnitPolymorphicContainerType
      sharing BinaryRelation.Domain = BaseType
      sharing BaseStructureMap.Start = BaseType
      sharing BaseStructureMap.End = BaseType
   end ): UnitPointeredTypeGenerating =
   struct
      structure PolymorphicContainerType =  X.PolymorphicContainerType
      structure PointeredTypeExtended =
         struct
            structure BaseType =  X.BaseType
            structure ContainerType =
               struct
                  type T =  BaseType.T PolymorphicContainerType.T
                  val eq =  X.PolymorphicContainerType.cong BaseType.eq
               end
            structure PointerType =
               struct
                  type T =  unit
                  fun eq (_, _) = true
               end
            structure BaseStructure =  BaseType
            structure BaseStructureMap =  X.BaseStructureMap

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

            val base_map =  BaseStructureMap.apply

            fun transition phi Option.NONE b =  b
              | transition phi (Option.SOME x) b
              = case(phi (x, b)) of
                   Option.NONE =>  b
                |  Option.SOME c => c

            fun is_in (x, c)
              = Option.isSome (Option.map (fn (y) => BaseType.eq(x, y)) c)

            fun subeq (c_1, c_2)
              = case(c_1) of
                   Option.NONE => true
                |  Option.SOME x => is_in (x, c_2)

         end
      structure AllZip =
         struct
            structure BinaryRelation =  X.BinaryRelation
            structure PointeredType =  PointeredTypeExtended

            val result =  PointeredTypeExtended.all_zip o X.BinaryRelation.apply

         end


      fun singleton (_, x) =  Option.SOME x

   end;
