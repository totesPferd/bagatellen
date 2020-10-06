use "general/double_structure.sig";
use "general/map.sig";
use "general/pair_type.sig";

signature DoubleMap =
   sig
      include Map
      structure FstMap: Map
      structure SndMap: Map
      structure Pair: PairType
      structure DoubleStart: DoubleStructure;
      structure DoubleEnd: DoubleStructure;
      sharing Pair = Map
      sharing DoubleStart = Start
      sharing DoubleEnd = End
      sharing Pair.FstType = FstMap.Map
      sharing Pair.SndType = SndMap.Map
   end;
