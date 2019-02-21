use "general/map.sig";
use "general/sum_type.sig";

signature SumMapExtension =
   sig
      structure FstMap: Map
      structure SndMap: Map
      structure SumMap: Map
      structure Start: SumType
      structure End: SumType
      sharing Start =  SumMap.Start
      sharing End =  SumMap.End
      sharing Start.FstType = FstMap.Start
      sharing Start.SndType = SndMap.Start
      sharing End.FstType =  FstMap.End
      sharing End.SndType =  SndMap.End

      val fst: SumMap.T -> FstMap.T
      val snd: SumMap.T -> SndMap.T

      val get_map: FstMap.T * SndMap.T -> SumMap.T

   end;
