use "general/compose_map.sig";
use "general/pair_map_extension.sig";

functor PairComposeMap(X:
   sig
      structure A: PairMapExtension
      structure B: PairMapExtension
      structure FstCM: ComposeMap
      structure SndCM: ComposeMap
      structure RPME: PairMapExtension
      sharing A.PairMap.Start = RPME.PairMap.Start
      sharing A.PairMap.End = B.PairMap.Start
      sharing B.PairMap.End = RPME.PairMap.End
      sharing FstCM.A = A.FstMap
      sharing FstCM.B = B.FstMap
      sharing FstCM.Result = RPME.FstMap
      sharing SndCM.A = A.SndMap
      sharing SndCM.B = B.SndMap
      sharing SndCM.Result = RPME.SndMap
      
   end ): ComposeMap =
   struct
      structure A =  X.A.PairMap
      structure B =  X.B.PairMap
      structure Result =  X.RPME.PairMap

      fun compose (f_1, f_2)
         =  let
               val fst_result =  X.FstCM.compose(X.A.fst f_1, X.B.fst f_2)
               val snd_result =  X.SndCM.compose(X.A.snd f_1, X.B.snd f_2)
            in X.RPME.get_map (fst_result, snd_result)
            end
   end;
