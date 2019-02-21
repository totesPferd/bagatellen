use "general/compose_map.sig";
use "general/sum_map_extension.sig";

functor SumComposeMap(X:
   sig
      structure A: SumMapExtension
      structure B: SumMapExtension
      structure FstCM: ComposeMap
      structure SndCM: ComposeMap
      structure RPME: SumMapExtension
      sharing A.SumMap.Start = RPME.SumMap.Start
      sharing A.SumMap.End = B.SumMap.Start
      sharing B.SumMap.End = RPME.SumMap.End
      sharing FstCM.A = A.FstMap
      sharing FstCM.B = B.FstMap
      sharing FstCM.Result = RPME.FstMap
      sharing SndCM.A = A.SndMap
      sharing SndCM.B = B.SndMap
      sharing SndCM.Result = RPME.SndMap
      
   end ): ComposeMap =
   struct
      structure A =  X.A.SumMap
      structure B =  X.B.SumMap
      structure Result =  X.RPME.SumMap

      fun compose (f_1, f_2)
         =  let
               val fst_result =  X.FstCM.compose(X.A.fst f_1, X.B.fst f_2)
               val snd_result =  X.SndCM.compose(X.A.snd f_1, X.B.snd f_2)
            in X.RPME.get_map (fst_result, snd_result)
            end
   end;
