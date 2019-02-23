use "general/map.sig";
use "general/type.sig";
use "pointered_types/pointered_compose_map.sig";
use "pointered_types/pointered_functor.sig";
use "pointered_types/pointered_generation.sig";
use "pointered_types/pointered_singleton.sig";
use "pointered_types/pointered_type.sig";

functor PointeredFunctor(X:
   sig
      structure Start: PointeredType
      structure End: PointeredType
      structure Map: Map
      structure ComposeMap: PointeredComposeMap
      structure Generation: PointeredGeneration
      structure Singleton: PointeredSingleton
      structure PointerType: Type
      sharing Map.Start = Start.BaseType
      sharing Map.End = End.BaseType
      sharing ComposeMap.A = Map
      sharing ComposeMap.B = Singleton.PointeredMap
      sharing ComposeMap.Result = Generation.PointeredMap
      sharing ComposeMap.PointerType = PointerType
      sharing Generation.Start = Start
      sharing Generation.End = End
      sharing Generation.PointerType = PointerType
      sharing Singleton.PointeredType = End
      sharing Singleton.PointerType = PointerType
   end) : PointeredFunctor =
   struct
      structure Start =  X.Start
      structure End =  X.End
      structure Map =  X.Map

      fun map m
         =  let
               val pm =  X.ComposeMap.compose(m, X.Singleton.singleton)
            in
               X.Generation.generate pm
            end
   end;
