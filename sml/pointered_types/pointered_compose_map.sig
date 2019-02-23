use "general/map.sig";
use "general/type.sig";
use "pointered_types/pointered_map.sig";

signature PointeredComposeMap =
   sig
      structure A: Map
      structure B: PointeredMap
      structure Result: PointeredMap
      structure PointerType: Type
      sharing A.Start = Result.Start
      sharing A.End = B.Start
      sharing B.End = Result.End
      sharing B.PointerType = PointerType
      sharing Result.PointerType = PointerType

      val compose: A.Map.T * B.Map.T -> Result.Map.T

   end;

