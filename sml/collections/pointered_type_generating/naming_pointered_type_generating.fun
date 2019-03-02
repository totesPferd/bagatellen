use "general/eqs.sig";
use "collections/naming_pointered_type_generating.sig";
use "collections/naming_polymorphic_container_type.sig";

functor NamingPointeredTypeGenerating(X:
   sig
      structure BaseType: Eqs
      structure PolymorphicContainerType: NamingPolymorphicContainerType
   end ): NamingPointeredTypeGenerating =
   struct
      structure PolymorphicContainerType =  X.PolymorphicContainerType
      structure PointeredType =
         struct
            structure BaseType =  X.BaseType
            structure ContainerType =
               struct
                  type T =  BaseType.T PolymorphicContainerType.T
                  val eq = ListPair.all (fn ((m, x), (n, y)) => BaseType.eq (x, y))
               end
            structure PointerType =
               struct
                  type T =  string Option.option ref
               end
      
            val empty         =  List.nil
            val is_empty      =  List.null
            fun select (n, c)
               =  case (List.find (fn (m, y) => (m = n)) c) of
                     Option.NONE =>  Option.NONE
                  |  Option.SOME (k, v) => Option.SOME v

            fun singleton (p, x) =  [ (p, x) ]

         end

   end;
