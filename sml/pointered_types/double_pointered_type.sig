use "general/double_structure.sig";
use "general/map.sig";
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
      structure BaseStructure: DoubleStructure
      structure BaseStructureMap: Map
      sharing BaseType.FstType = FstType.BaseType
      sharing BaseType.SndType = SndType.BaseType
      sharing ContainerType.FstType = FstType.ContainerType
      sharing ContainerType.SndType = SndType.ContainerType
      sharing PointerType.FstType = FstType.PointerType
      sharing PointerType.SndType = SndType.PointerType
      sharing BaseStructure.FstStruct =  FstType.BaseStructure
      sharing BaseStructure.SndStruct =  SndType.BaseStructure
      sharing BaseStructureMap.Start =  BaseStructure
      sharing BaseStructureMap.End =  BaseStructure

      val empty:     ContainerType.T
      val is_empty:  ContainerType.T -> bool
      val select:    PointerType.T * ContainerType.T -> BaseType.T Option.option

      val base_map:  BaseStructureMap.Map.T -> BaseType.T -> BaseType.T

   end;
