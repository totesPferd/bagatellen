use "general/map.sig";
use "general/type.sig";

signature PointeredMap =
   sig
      include Map

      structure PointerType: Type
   end;
