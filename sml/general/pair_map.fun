use "general/map.sig";
use "general/pair.sig";

functor PairMap(X:
   sig
      structure Start: Pair
      structure End: Pair
      structure FstMap: Map
      structure SndMap: Map
      sharing Start.FstType = FstMap.Start
      sharing Start.SndType = SndMap.Start
      sharing End.FstType =  FstMap.End
      sharing End.SndType =  SndMap.End
   end ): Map =
   struct
      structure Start =  X.Start
      structure End =  X.End

      type T =  X.FstMap.T * X.SndMap.T

      fun apply((f_1, f_2), p) =  End.tuple(X.FstMap.apply(f_1, Start.fst p), X.SndMap.apply(f_2, Start.snd p))

   end;
