use "general/pair_type.sig";
use "general/sum_type.sig";
use "pointered_types/double_pointered_type.sig";
use "pointered_types/pointered_type.sig";

functor DoublePointeredType(X:
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
   end ): DoublePointeredType =
   struct

      structure FstType =  X.FstType
      structure SndType =  X.SndType
      structure BaseType =  X.BaseType
      structure ContainerType =  X.ContainerType
      structure PointerType =  X.PointerType
      structure BaseStructure =
         struct
            structure Fst =  X.FstType.BaseStructure
            structure Snd =  X.SndType.BaseStructure
         end

      val empty =    ContainerType.tuple(FstType.empty, SndType.empty)
      fun is_empty c
         =  (FstType.is_empty (ContainerType.fst c)) andalso (SndType.is_empty (ContainerType.snd c))
      fun select (p, c)
         =  PointerType.traverse (
               (fn fst_p => Option.map BaseType.fst_inj (FstType.select(fst_p, ContainerType.fst c)))
            ,  (fn snd_p => Option.map BaseType.snd_inj (SndType.select(snd_p, ContainerType.snd c))) )
               p

   end;
