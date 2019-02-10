use "collections/eqs.sig";
use "collections/pointered_type.fun";
use "collections/unit_pointered_type.sig";
use "collections/unit_polymorphic_pointered_type.sml";

functor UnitPointeredType(B: Eqs): UnitPointeredType =
   struct
      structure UnitPolymorphicPointeredType =  UnitPolymorphicPointeredType
      structure PointeredType =  PointeredType(
         struct
            structure B =  B
            structure PPT =  UnitPolymorphicPointeredType
         end )

      val get_val =  UnitPolymorphicPointeredType.get_val

   end;
