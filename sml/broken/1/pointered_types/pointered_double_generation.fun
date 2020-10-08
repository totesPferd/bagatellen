use "general/sum_type.sig";
use "pointered_types/double_pointered_type.sig";
use "pointered_types/pointered_double_map.sig";
use "pointered_types/pointered_generation.sig";

functor PointeredDoubleGeneration(X:
   sig
      structure PointeredMap: PointeredDoubleMap
      structure Start: DoublePointeredType
      structure End: DoublePointeredType
      structure PointerType: SumType
      structure FstPointeredGeneration:  PointeredGeneration
      structure SndPointeredGeneration:  PointeredGeneration
      sharing Start.PointerType = PointerType
      sharing End.PointerType = PointerType
      sharing PointeredMap.PointerType = PointerType
      sharing PointeredMap.Start = Start.BaseType
      sharing PointeredMap.End = End.ContainerType
      sharing FstPointeredGeneration.Start.ContainerType = Start.ContainerType.FstType
      sharing SndPointeredGeneration.Start.ContainerType = Start.ContainerType.SndType
      sharing FstPointeredGeneration.End.ContainerType = End.ContainerType.FstType
      sharing SndPointeredGeneration.End.ContainerType = End.ContainerType.SndType
      sharing FstPointeredGeneration.PointeredMap = PointeredMap.FstMap
      sharing SndPointeredGeneration.PointeredMap = PointeredMap.SndMap
   end ): PointeredGeneration =
   struct
      structure Start =  X.Start
      structure End =  X.End
      structure PointeredMap =  X.PointeredMap
      structure PointerType =  X.PointerType

      fun generate pm c
         =  End.ContainerType.tuple(
               (X.FstPointeredGeneration.generate (PointeredMap.Pair.fst pm) (Start.ContainerType.fst c))
            ,  (X.SndPointeredGeneration.generate (PointeredMap.Pair.snd pm) (Start.ContainerType.snd c)) )
   end;
