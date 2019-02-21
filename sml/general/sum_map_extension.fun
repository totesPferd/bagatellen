use "general/map.sig";
use "general/sum_type.sig";
use "general/sum_map_extension.sig";

functor SumMapExtension(X:
   sig
      structure Start: SumType
      structure End: SumType
      structure FstMap: Map
      structure SndMap: Map
      sharing Start.FstType = FstMap.Start
      sharing Start.SndType = SndMap.Start
      sharing End.FstType =  FstMap.End
      sharing End.SndType =  SndMap.End
   end ): SumMapExtension =
   struct
      structure Start =  X.Start
      structure End =  X.End
      structure FstMap =  X.FstMap
      structure SndMap =  X.SndMap

      structure SumMap =
         struct
            structure Start =  Start
            structure End =  End
      
            type T =  FstMap.T * SndMap.T
      
            fun apply (f_1, f_2)
               =  Start.traverse (
                     ( fn x => End.fst_inj (FstMap.apply f_1 x))
                  ,  ( fn y => End.snd_inj (SndMap.apply f_2 y)) )
         end

      fun fst (f_1, f_2) =  f_1
      fun snd (f_1, f_2) =  f_2

      fun get_map (fst_m, snd_m) =  (fst_m, snd_m)

   end;
