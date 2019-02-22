use "general/map.sig";
use "general/pair_type.sig";

signature DoubleMap =
   sig
      include Map
      structure FstMap: Map
      structure SndMap: Map
      structure Pair: PairType
      sharing Pair = Map
      sharing Pair.FstType = FstMap.Map
      sharing Pair.SndType = SndMap.Map
   end;
