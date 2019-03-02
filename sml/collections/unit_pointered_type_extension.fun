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
      structure PointeredTypeExtended =  PointeredTypeExtended(
         struct
            structure B =  B
            structure PPT =  UnitPolymorphicPointeredType
         end )

      structure PointeredSingleton =
         struct
            structure PointeredType =  PointeredTypeExtended
            structure PointeredMap: PointeredBaseMap =
               struct
                  structure Start =  PointeredTypeExtended.BaseType
                  structure End =  PointeredTypeExtended.ContainerType
                  structure PointerType =  PointeredTypeExtended.PointerType
                  structure Map =
                     struct
                        type T =  PointerType.T * Start.T -> End.T
                     end
                  fun apply f (p, x) =  f (p, x)
                  fun get_map f =  f
               end
            structure PointerType =  PointeredTypeExtended.PointerType
            val singleton =  UnitPolymorphicPointeredType.singleton
         end

   end;
