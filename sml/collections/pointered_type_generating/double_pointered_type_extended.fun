use "collections/pointered_type_extended.sig";
use "collections/double_pointered_type_extended.sig";
use "general/sum_type.sig";
use "pointered_types/double_pointered_type.sig";

functor DoublePointeredTypeExtended(X:
   sig
      structure FstType: PointeredTypeExtended
      structure SndType: PointeredTypeExtended
      structure BaseType:  SumType
      structure ContainerType: PairType
      structure PointerType: SumType
      structure DoublePointeredType: DoublePointeredType
      sharing BaseType.FstType = FstType.BaseType
      sharing BaseType.SndType = SndType.BaseType
      sharing ContainerType.FstType = FstType.ContainerType
      sharing ContainerType.SndType = SndType.ContainerType
      sharing PointerType.FstType = FstType.PointerType
      sharing PointerType.SndType = SndType.PointerType
      sharing DoublePointeredType.FstType =  FstType
      sharing DoublePointeredType.SndType =  SndType
      sharing DoublePointeredType.BaseType =  BaseType
      sharing DoublePointeredType.ContainerType =  ContainerType
      sharing DoublePointeredType.PointerType =  PointerType
   end ): DoublePointeredTypeExtended =
   struct
      structure FstType =  X.FstType
      structure SndType =  X.SndType
      structure BaseType =  X.BaseType
      structure ContainerType =  X.ContainerType
      structure PointerType =  X.PointerType

      val select =  X.DoublePointeredType.select
      val empty =  X.DoublePointeredType.empty
      val is_empty =  X.DoublePointeredType.is_empty


      fun all phi c
         =      (FstType.all (phi o BaseType.fst_inj) (ContainerType.fst c))
            andalso
                (SndType.all (phi o BaseType.snd_inj) (ContainerType.snd c))

      fun all_zip phi (c_1, c_2)
         =      (FstType.all_zip (fn (x, y) => phi(BaseType.fst_inj x, BaseType.fst_inj y)) (ContainerType.fst c_1, ContainerType.fst c_2))
            andalso
                (SndType.all_zip (fn (x, y) => phi(BaseType.snd_inj x, BaseType.snd_inj y)) (ContainerType.snd c_1, ContainerType.snd c_2))

      fun fe b
         =   BaseType.traverse (
                   (fn x => ContainerType.tuple(FstType.fe x, SndType.empty))
                ,  (fn y => ContainerType.tuple(FstType.empty, SndType.fe y)) )
                b

      fun is_in (b, c)
         =   BaseType.traverse (
                   (fn x => FstType.is_in (x, ContainerType.fst c))
                ,  (fn y => SndType.is_in (y, ContainerType.snd c)) )
                b

      fun subeq (c_1, c_2)
         =     FstType.subeq (ContainerType.fst c_1, ContainerType.fst c_2)
            andalso
               SndType.subeq (ContainerType.snd c_1, ContainerType.snd c_2)


      fun filter phi c
         =  let
               val v_1 =  FstType.filter (phi o BaseType.fst_inj) (ContainerType.fst c)
               val v_2 =  SndType.filter (phi o BaseType.snd_inj) (ContainerType.snd c)
            in ContainerType.tuple(v_1, v_2)
            end

      fun transition phi c b
         =  let
               val v_1 =  FstType.transition (fn (x, b') => phi(BaseType.fst_inj x, b')) (ContainerType.fst c) b
               val v_2 =  SndType.transition (fn (x, b') => phi(BaseType.snd_inj x, b')) (ContainerType.snd c) v_1
            in v_2
            end


   end;

