use "general/sum_type.sig";
use "pointered_types/double_pointered_type.sig";
use "pointered_types/pointered_double_map.sig";
use "pointered_types/pointered_double_singleton.sig";
use "pointered_types/pointered_singleton.sig";

functor PointeredDoubleSingleton(X:
   sig
      structure PointeredType: DoublePointeredType
      structure PointeredMap: PointeredDoubleMap
      structure PointerType: SumType
      structure FstSingleton: PointeredSingleton
      structure SndSingleton: PointeredSingleton
      sharing PointeredType.FstType = FstSingleton.PointeredType
      sharing PointeredType.SndType = SndSingleton.PointeredType
      sharing PointeredType.PointerType = PointerType
      sharing PointeredMap.FstMap = FstSingleton.PointeredMap
      sharing PointeredMap.SndMap = SndSingleton.PointeredMap
      sharing PointeredMap.PointerType = PointerType
   end ): PointeredDoubleSingleton =
   struct

      structure PointeredType =  X.PointeredType
      structure PointeredMap =  X.PointeredMap
      structure PointerType =  X.PointerType
      structure FstSingleton =  X.FstSingleton
      structure SndSingleton =  X.SndSingleton

      val singleton =  PointeredMap.Pair.tuple(
            FstSingleton.singleton
         ,  SndSingleton.singleton )

   end;
