use "general/sum_type.sig";
use "pointered_types/double_pointered_type.sig";
use "pointered_types/pointered_double_map.sig";
use "pointered_types/pointered_double_predicate.sig";
use "pointered_types/pointered_predicate.sig";

functor PointeredDoublePredicate(X:
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
   end ): PointeredDoublePredicate =
   struct

      structure PointeredType =  X.PointeredType
      structure PointeredMap =  X.PointeredMap
      structure PointerType =  X.PointerType
      structure FstPredicate =  X.FstPredicate
      structure SndPredicate =  X.SndPredicate

      val predicate =  PointeredType.BaseType.traverse (
            FstPredicate.predicate
         ,  SndPredicate.predicate )
      val predicate_map =  PointeredMap.Pair.tuple (
            FstPredicate.predicate_map
         ,  SndPredicate.predicate_map )

   end;
