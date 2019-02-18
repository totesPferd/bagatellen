use "collections/eqs.sig";
use "collections/pointered_type.fun";
use "collections/unit_pointered_type_extension.sig";
use "collections/unit_polymorphic_pointered_type.sml";

functor UnitPointeredTypeExtension(B: Eqs): UnitPointeredTypeExtension =
   struct
      structure UnitPolymorphicPointeredType =  UnitPolymorphicPointeredType
      structure UnitType =  UnitPolymorphicPointeredType.PointerType
      structure PointeredType =  PointeredType(
         struct
            structure B =  B
            structure PPT =  UnitPolymorphicPointeredType
         end )

   end;
