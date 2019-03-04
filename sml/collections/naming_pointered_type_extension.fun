use "collections/naming_pointered_type_extension.sig";
use "collections/naming_pointered_type_generating.sig";
use "collections/pointered_type_extended.sig";
use "collections/string_type.sig";

functor NamingPointeredTypeExtension(X: NamingPointeredTypeGenerating): NamingPointeredTypeExtension =
   struct
      structure StringType: StringType =
         struct
            type T =  string
            fun point s =  s
            fun eq(s, t) =  (s = t)
         end
      structure PointeredTypeExtended: PointeredTypeExtended =
         struct
            structure BaseType =  X.PointeredTypeExtended.BaseType
            structure PointerType =  StringType
            structure ContainerType =  X.PointeredTypeExtended.ContainerType

            fun select (p, c)
               =  case(List.find (fn (m, x) => (!m = (Option.SOME p))) c) of
                     Option.NONE =>  Option.NONE
                  |  Option.SOME (k, v) =>  Option.SOME v

            val empty =  X.PointeredTypeExtended.empty
            val is_empty =  X.PointeredTypeExtended.is_empty

            val all =  X.PointeredTypeExtended.all
            val all_zip =  X.PointeredTypeExtended.all_zip
            val fe =  X.PointeredTypeExtended.fe
            val is_in =  X.PointeredTypeExtended.is_in
            val subeq =  X.PointeredTypeExtended.subeq

            val filter =  X.PointeredTypeExtended.filter
            val transition =  X.PointeredTypeExtended.transition

         end

      val sum =  X.sum

      val add        =  X.add
      val adjoin     =  X.adjoin
      val transition =  X.transition
      val get_name   =  X.get_name
      val set_name   =  X.set_name
      val uniquize   =  X.uniquize

   end;
