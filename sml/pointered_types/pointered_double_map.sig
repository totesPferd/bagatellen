use "general/pair_type.sig";
use "pointered_types/pointered_map.sig";

signature PointeredDoubleMap =
   sig
      include PointeredMap
      structure FstMap: PointeredMap
      structure SndMap: PointeredMap
      structure Pair: PairType
      sharing Pair = Map
      sharing Pair.FstType = FstMap.Map
      sharing Pair.SndType = SndMap.Map
      sharing FstMap.PointerType = SndMap.PointerType
   end;
