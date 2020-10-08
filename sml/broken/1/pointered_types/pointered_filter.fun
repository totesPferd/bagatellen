use "general/map.sig";
use "general/type.sig";
use "pointered_types/pointered_filter.sig";
use "pointered_types/pointered_generation.sig";
use "pointered_types/pointered_predicate.sig";
use "pointered_types/pointered_type.sig";

functor PointeredFilter(X:
   sig
      structure PointeredPredicate: PointeredPredicate
      structure PointeredType: PointeredType
      structure Generation: PointeredGeneration
      structure PointerType: Type
      sharing PointeredPredicate.PointeredMap = Generation.PointeredMap
      sharing PointeredPredicate.PointeredType = PointeredType
      sharing PointeredPredicate.PointerType =  PointerType
      sharing Generation.Start = PointeredType
      sharing Generation.End = PointeredType
      sharing Generation.PointerType = PointerType
   end) : PointeredFilter =
   struct
      structure PointeredType =  X.PointeredType

      val filter =  X.Generation.generate X.PointeredPredicate.predicate_map

   end;
