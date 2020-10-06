use "general/pair_type.sig";
use "general/sum_type.sig";
use "general/type.sig";
use "pointered_types/pointered_double_map.sig";
use "pointered_types/pointered_map.sig";

functor PointeredDoubleMap(X:
   sig
      structure FstMap: PointeredMap
      structure SndMap: PointeredMap
      structure Pair: PairType
      structure PointerType: SumType
      sharing Pair.FstType = FstMap.Map
      sharing Pair.SndType = SndMap.Map
      sharing FstMap.PointerType = PointerType.FstType
      sharing SndMap.PointerType = PointerType.SndType
   end ): PointeredDoubleMap =
   struct
      structure FstMap =  X.FstMap
      structure SndMap =  X.SndMap
      structure Pair =  X.Pair
      structure PointerType =  X.PointerType
      structure Start =
         struct
            structure FstStruct =  X.FstMap.Start
            structure SndStruct =  X.SndMap.Start
         end
      structure End =
         struct
            structure FstStruct =  X.FstMap.End
            structure SndStruct =  X.SndMap.End
         end

      structure Map =  Pair

   end;
