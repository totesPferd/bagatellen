use "collections/naming_pointered_type_extension.sig";
use "collections/naming_polymorphic_pointered_type.sml";
use "collections/pointered_type.fun";
use "general/eqs.sig";
use "pointered_types/pointered_base_map.sig";

functor NamingPointeredTypeExtension(B: Eqs): NamingPointeredTypeExtension =
   struct
      structure NamingPolymorphicPointeredType =  NamingPolymorphicPointeredType
      structure StringType =  NamingPolymorphicPointeredType.PointerType
      structure PointeredType2 =  PointeredType2(
         struct
            structure B =  B
            structure PPT =  NamingPolymorphicPointeredType
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
            val singleton =  NamingPolymorphicPointeredType.singleton
         end

      val sum =  NamingPolymorphicPointeredType.sum

      val add        =  NamingPolymorphicPointeredType.p_add B.eq
      val adjoin     =  NamingPolymorphicPointeredType.adjoin
      val transition =  NamingPolymorphicPointeredType.full_transition
      val get_name   =  NamingPolymorphicPointeredType.p_get_name B.eq
      val set_name   =  NamingPolymorphicPointeredType.p_set_name B.eq
      val uniquize   =  NamingPolymorphicPointeredType.uniquize

   end;
