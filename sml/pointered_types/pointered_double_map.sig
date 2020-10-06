use "general/map.sig";
use "general/pair_type.sig";
use "pointered_types/pointered_map.sig";

signature PointeredDoubleMap =
   sig
      include Map
      structure FstMap: PointeredMap
      structure SndMap: PointeredMap
      structure Pair: PairType
      structure PointerType: SumType
      sharing Pair = Map
      sharing Pair.FstType = FstMap.Map
      sharing Pair.SndType = SndMap.Map
      sharing PointerType.FstType = FstMap.PointerType
      sharing PointerType.SndType = SndMap.PointerType
   end;
