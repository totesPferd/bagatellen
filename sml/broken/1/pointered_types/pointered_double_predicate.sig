use "general/sum_type.sig";
use "pointered_types/double_pointered_type.sig";
use "pointered_types/pointered_double_map.sig";
use "pointered_types/pointered_predicate.sig";

signature PointeredDoublePredicate =
   sig
      structure PointeredType: DoublePointeredType
      structure PointeredMap: PointeredDoubleMap
      structure PointerType: SumType
      structure FstPredicate: PointeredPredicate
      structure SndPredicate: PointeredPredicate
      sharing PointeredType.FstType = FstPredicate.PointeredType
      sharing PointeredType.SndType = SndPredicate.PointeredType
      sharing PointeredType.PointerType = PointerType
      sharing PointeredMap.FstMap = FstPredicate.PointeredMap
      sharing PointeredMap.SndMap = SndPredicate.PointeredMap
      sharing PointeredMap.PointerType = PointerType

      val predicate:  PointeredType.BaseType.T -> bool
      val predicate_map: PointeredMap.Map.T

   end;
