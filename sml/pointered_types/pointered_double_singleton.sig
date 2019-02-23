use "general/sum_type.sig";
use "pointered_types/double_pointered_type.sig";
use "pointered_types/pointered_double_map.sig";
use "pointered_types/pointered_singleton.sig";

signature PointeredDoubleSingleton =
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

      val singleton: PointeredMap.Map.T

   end;
