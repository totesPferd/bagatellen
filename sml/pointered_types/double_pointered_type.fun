use "general/double_map.sig";
use "general/double_structure.sig";
use "general/map.sig";
use "general/pair_type.sig";
use "general/sum_type.sig";
use "pointered_types/double_pointered_type.sig";
use "pointered_types/pointered_type.sig";

functor DoublePointeredType(X:
   sig
      structure FstType: PointeredType
      structure SndType: PointeredType
      structure BaseStructure: DoubleStructure
      structure BaseType: SumType
      structure ContainerType: PairType
      structure BaseStructureMap: DoubleMap
      structure PointerType: SumType
      sharing BaseType.FstType = FstType.BaseType
      sharing BaseType.SndType = SndType.BaseType
      sharing ContainerType.FstType = FstType.ContainerType
      sharing ContainerType.SndType = SndType.ContainerType
      sharing PointerType.FstType = FstType.PointerType
      sharing PointerType.SndType = SndType.PointerType
      sharing BaseStructure.FstStruct =  FstType.BaseStructure
      sharing BaseStructure.SndStruct =  SndType.BaseStructure
      sharing BaseStructureMap.FstMap =  FstType.BaseStructureMap
      sharing BaseStructureMap.SndMap =  SndType.BaseStructureMap
      sharing BaseStructureMap.Start =  BaseStructure
      sharing BaseStructureMap.End =  BaseStructure
   end ): DoublePointeredType =
   struct

      structure FstType =  X.FstType
      structure SndType =  X.SndType
      structure BaseType =  X.BaseType
      structure ContainerType =  X.ContainerType
      structure PointerType =  X.PointerType
      structure BaseStructure =  X.BaseStructure
      structure BaseStructureMap =  X.BaseStructureMap

      val empty =    ContainerType.tuple(FstType.empty, SndType.empty)
      fun is_empty c
         =  (FstType.is_empty (ContainerType.fst c)) andalso (SndType.is_empty (ContainerType.snd c))
      fun select (p, c)
         =  PointerType.traverse (
               (fn fst_p => Option.map BaseType.fst_inj (FstType.select(fst_p, ContainerType.fst c)))
            ,  (fn snd_p => Option.map BaseType.snd_inj (SndType.select(snd_p, ContainerType.snd c))) )
               p

      fun base_map bm
         =  X.BaseType.traverse (
                  (X.BaseType.fst_inj o (FstType.base_map (X.BaseStructureMap.Pair.fst bm)))
               ,  (X.BaseType.snd_inj o (SndType.base_map (X.BaseStructureMap.Pair.snd bm))) )

   end;
