use "general/eqs.sig";
use "collections/pointered_type.fun";
use "collections/unit_pointered_type_extension.sig";
use "collections/unit_polymorphic_pointered_type.sml";
use "pointered_types/pointered_base_map.sig";
use "pointered_types/pointered_singleton.sig";

functor UnitPointeredTypeExtension(B: Eqs): UnitPointeredTypeExtension =
   struct
      structure UnitPolymorphicPointeredType =  UnitPolymorphicPointeredType
      structure UnitType =  UnitPolymorphicPointeredType.PointerType
      structure PointeredType2 =  PointeredType2(
         struct
            structure B =  B
            structure PPT =  UnitPolymorphicPointeredType
         end )

      structure PointeredSingleton =
         struct
            structure PointeredType =  PointeredType2
            structure PointeredMap: PointeredBaseMap =
               struct
                  structure Start =  PointeredType2.BaseType
                  structure End =  PointeredType2.ContainerType
                  structure PointerType =  PointeredType2.PointerType
                  structure Map =
                     struct
                        type T =  PointerType.T * Start.T -> End.T
                     end
                  fun apply f (p, x) =  f (p, x)
                  fun get_map f =  f
               end
            structure PointerType =  PointeredType2.PointerType
            val singleton =  UnitPolymorphicPointeredType.singleton
         end

   end;
