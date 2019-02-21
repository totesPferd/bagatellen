use "general/map.sig";
use "general/pair.sig";
use "general/pair_map_extension.sig";

functor PairMapExtension(X:
   sig
      structure Start: Pair
      structure End: Pair
      structure FstMap: Map
      structure SndMap: Map
      sharing Start.FstType = FstMap.Start
      sharing Start.SndType = SndMap.Start
      sharing End.FstType =  FstMap.End
      sharing End.SndType =  SndMap.End
   end ): PairMapExtension =
   struct
      structure Start =  X.Start
      structure End =  X.End
      structure FstMap =  X.FstMap
      structure SndMap =  X.SndMap

      structure PairMap =
         struct
            structure Start =  Start
            structure End =  End
      
            type T =  FstMap.T * SndMap.T
      
            fun apply (f_1, f_2) p =  End.tuple(FstMap.apply f_1 (Start.fst p), SndMap.apply f_2 (Start.snd p))
         end

      fun get_map (fst_m, snd_m) =  (fst_m, snd_m)

   end;
