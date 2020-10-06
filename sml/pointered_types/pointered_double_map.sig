use "general/double_map.sig";
use "general/map.sig";
use "general/pair_type.sig";
use "pointered_types/pointered_map.sig";

signature PointeredDoubleMap =
   sig
      include DoubleMap
      structure FstPointeredMap: PointeredMap
      structure SndPointeredMap: PointeredMap
      structure PointerType: SumType
      sharing FstPointeredMap = FstMap
      sharing SndPointeredMap = SndMap
      sharing PointerType.FstType = FstPointeredMap.PointerType
      sharing PointerType.SndType = SndPointeredMap.PointerType
   end;
