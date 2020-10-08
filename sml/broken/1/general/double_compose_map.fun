use "general/compose_map.sig";
use "general/double_map.sig";
use "general/double_structure.sig";
use "general/map.sig";

functor DoubleComposeMap(X:
   sig
      structure FstCM: ComposeMap
      structure SndCM: ComposeMap
      structure ADM: DoubleMap
      structure BDM: DoubleMap
      structure Result: DoubleMap
      structure Start: DoubleStructure
      structure Middle: DoubleStructure
      structure End: DoubleStructure
      sharing FstCM.A = ADM.FstMap
      sharing FstCM.B = BDM.FstMap
      sharing FstCM.Result = Result.FstMap
      sharing SndCM.A = ADM.SndMap
      sharing SndCM.B = BDM.SndMap
      sharing SndCM.Result =  Result.SndMap
      sharing FstCM.A.Start = Start.FstStruct
      sharing FstCM.B.End = End.FstStruct
      sharing SndCM.A.Start = Start.SndStruct
      sharing SndCM.B.End = End.SndStruct
      sharing FstCM.A.End = Middle.FstStruct
      sharing FstCM.B.Start = Middle.FstStruct
      sharing SndCM.A.End = Middle.SndStruct
      sharing SndCM.B.Start = Middle.SndStruct
      sharing ADM.Start = Start
      sharing ADM.End = Middle
      sharing BDM.Start = Middle
      sharing BDM.End = End
      sharing Result.Start = Start
      sharing Result.End = End
   end ): ComposeMap =
   struct
      structure A =  X.ADM
      structure B =  X.BDM
      structure Result =  X.Result

      fun compose (f, g)
         = Result.Pair.tuple(X.FstCM.compose(A.Pair.fst f, B.Pair.fst g), X.SndCM.compose(A.Pair.snd f, B.Pair.snd g))

   end;
