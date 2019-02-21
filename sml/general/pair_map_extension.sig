use "general/map.sig";
use "general/pair.sig";

signature PairMapExtension =
   sig
      structure FstMap: Map
      structure SndMap: Map
      structure PairMap: Map
      structure Start: Pair
      structure End: Pair
      sharing Start =  PairMap.Start
      sharing End =  PairMap.End
      sharing Start.FstType = FstMap.Start
      sharing Start.SndType = SndMap.Start
      sharing End.FstType =  FstMap.End
      sharing End.SndType =  SndMap.End

      val fst: PairMap.T -> FstMap.T
      val snd: PairMap.T -> SndMap.T

      val get_map: FstMap.T * SndMap.T -> PairMap.T

   end;
