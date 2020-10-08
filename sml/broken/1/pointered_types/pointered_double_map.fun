use "general/pair_type.sig";
use "general/sum_type.sig";
use "general/type.sig";
use "pointered_types/pointered_double_map.sig";
use "pointered_types/pointered_map.sig";

functor PointeredDoubleMap(X:
   sig
      structure FstPointeredMap: PointeredMap
      structure SndPointeredMap: PointeredMap
      structure Pair: PairType
      structure PointerType: SumType
      sharing Pair.FstType = FstPointeredMap.Map
      sharing Pair.SndType = SndPointeredMap.Map
      sharing FstPointeredMap.PointerType = PointerType.FstType
      sharing SndPointeredMap.PointerType = PointerType.SndType
   end ): PointeredDoubleMap =
   struct
      structure FstMap =  X.FstPointeredMap
      structure SndMap =  X.SndPointeredMap
      structure FstPointeredMap =  FstMap
      structure SndPointeredMap =  SndMap
      structure Pair =  X.Pair
      structure PointerType =  X.PointerType
      structure DoubleStart =
         struct
            structure FstStruct =  X.FstPointeredMap.Start
            structure SndStruct =  X.SndPointeredMap.Start
         end
      structure DoubleEnd =
         struct
            structure FstStruct =  X.FstPointeredMap.End
            structure SndStruct =  X.SndPointeredMap.End
         end
      structure Start =  DoubleStart
      structure End =  DoubleEnd

      structure Map =  Pair

   end;
