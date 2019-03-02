use "general/type.sig";
use "collections/naming_pointered_type_generating.sig";
use "collections/naming_polymorphic_container_type.sig";

functor NamingPointeredTypeGenerating(X:
   sig
      structure BaseType: Type
      structure PolymorphicContainerType: NamingPolymorphicContainerType
   end ): NamingPointeredTypeGenerating =
   struct
      structure PolymorphicContainerType =  X.PolymorphicContainerType
      structure BaseType =  X.BaseType
      structure ContainerType =
         struct
            type T =  BaseType.T PolymorphicContainerType.T
         end
      structure PointerType =
         struct
            type T =  string
         end

      val empty         =  List.nil
      val is_empty      =  List.null
      fun select (n, c)
         =  case (List.find (fn (m, y) => (!m = Option.SOME n)) c) of
               Option.NONE =>  Option.NONE
            |  Option.SOME (k, v) => Option.SOME v

   end;
