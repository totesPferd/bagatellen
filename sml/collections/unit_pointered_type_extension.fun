use "collections/unit_pointered_type_extension.sig";
use "collections/unit_pointered_type_generating.sig";
use "collections/unit_type.sig";

functor UnitPointeredTypeExtension(X: UnitPointeredTypeGenerating): UnitPointeredTypeExtension =
   struct
      structure UnitType: UnitType =
         struct
            type T =  unit
            val point =  ()
            fun eq(x, y) =  true
         end
      structure PointeredTypeExtended =  X.PointeredTypeExtended

   end;
