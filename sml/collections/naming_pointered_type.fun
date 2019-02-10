use "collections/eqs.sig";
use "collections/naming_pointered_type.sig";
use "collections/naming_polymorphic_pointered_type.sml";
use "collections/pointered_type.fun";

functor NamingPointeredType(B: Eqs): NamingPointeredType =
   struct
      structure NamingPolymorphicPointeredType =  NamingPolymorphicPointeredType
      structure PointeredType =  PointeredType(
         struct
            structure B =  B
            structure PPT =  NamingPolymorphicPointeredType
         end )

      val new =       NamingPolymorphicPointeredType.new
      val get_name =  NamingPolymorphicPointeredType.p_get_name B.eq
      val set_name =  NamingPolymorphicPointeredType.p_set_name B.eq
      val uniquize =  NamingPolymorphicPointeredType.uniquize

   end;
