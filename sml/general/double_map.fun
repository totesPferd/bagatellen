use "general/double_map.sig";
use "general/map.sig";
use "general/pair_type.sig";

functor DoubleMap(X:
   sig
      structure FstMap: Map
      structure SndMap: Map
      structure Pair: PairType
      sharing Pair.FstType = FstMap.Map
      sharing Pair.SndType = SndMap.Map
   end ): DoubleMap =
   struct
      structure FstMap =  X.FstMap
      structure SndMap =  X.SndMap
      structure Pair =  X.Pair
      structure DoubleStart =
         struct
            structure FstStruct =  X.FstMap.Start
            structure SndStruct =  X.SndMap.Start
         end
      structure DoubleEnd =
         struct
            structure FstStruct =  X.FstMap.End
            structure SndStruct =  X.SndMap.End
         end
      structure Start =  DoubleStart
      structure End =  DoubleEnd

      structure Map =  Pair

   end;
