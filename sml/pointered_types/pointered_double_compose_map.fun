use "general/compose_map.sig";
use "general/double_map.sig";
use "general/double_structure.sig";
use "general/map.sig";
use "general/sum_type.sig";
use "general/type.sig";
use "pointered_types/pointered_compose_map.sig";
use "pointered_types/pointered_double_map.sig";

functor PointeredDoubleComposeMap(X:
   sig
      structure FstCM: PointeredComposeMap
      structure SndCM: PointeredComposeMap
      structure ADM: DoubleMap
      structure BDM: PointeredDoubleMap
      structure Result: PointeredDoubleMap
      structure Start: DoubleStructure
      structure Middle: DoubleStructure
      structure End: DoubleStructure
      structure PointerType: SumType
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
      sharing BDM.PointerType = PointerType
      sharing Result.PointerType = PointerType
      sharing FstCM.PointerType = PointerType.FstType
      sharing SndCM.PointerType = PointerType.SndType
   end ): PointeredComposeMap =
   struct
      structure A =  X.ADM
      structure B =  X.BDM
      structure Result =  X.Result
      structure PointerType =  X.PointerType

      fun compose (f, g)
         = Result.Pair.tuple(X.FstCM.compose(A.Pair.fst f, B.Pair.fst g), X.SndCM.compose(A.Pair.snd f, B.Pair.snd g))

   end;
