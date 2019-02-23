use "general/pair_type.sig";
use "general/sum_type.sig";
use "pointered_types/pointered_type.sig";

signature DoublePointeredType =
   sig
      structure FstType: PointeredType
      structure SndType: PointeredType
      structure BaseType: SumType
      structure ContainerType: PairType
      structure PointerType: SumType
      sharing BaseType.FstType = FstType.BaseType
      sharing BaseType.SndType = SndType.BaseType
      sharing ContainerType.FstType = FstType.ContainerType
      sharing ContainerType.SndType = SndType.ContainerType
      sharing PointerType.FstType = FstType.PointerType
      sharing PointerType.SndType = SndType.PointerType

      val empty:     ContainerType.T
      val is_empty:  ContainerType.T -> bool
      val select:    PointerType.T * ContainerType.T -> BaseType.T Option.option

   end;
