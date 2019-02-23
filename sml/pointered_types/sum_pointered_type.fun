use "general/pair_type.sig";
use "general/sum_type.sig";
use "pointered_types/pointered_type.sig";

functor SumPointeredType(X:
   sig
      structure FstPT: PointeredType
      structure SndPT: PointeredType
      structure BaseSum: SumType
      structure PointerSum: SumType
      structure ContainerPair: PairType
      sharing FstPT.BaseType = BaseSum.FstType
      sharing SndPT.BaseType = BaseSum.SndType
      sharing FstPT.PointerType = PointerSum.FstType
      sharing SndPT.PointerType = PointerSum.SndType
      sharing FstPT.ContainerType = ContainerPair.FstType
      sharing SndPT.ContainerType = ContainerPair.SndType
   end ): PointeredType =
   struct
      structure BaseType =  X.BaseSum
      structure ContainerType = X.ContainerPair
      structure PointerType =  X.PointerSum

      val empty =  X.ContainerPair.tuple(X.FstPT.empty, X.SndPT.empty)
      fun is_empty c
         =  (X.FstPT.is_empty (X.ContainerPair.fst c)) andalso (X.SndPT.is_empty (X.ContainerPair.snd c))

      fun select (p, c)
         =  X.PointerSum.traverse (
               (fn fst_p =>  Option.map X.BaseSum.fst_inj (X.FstPT.select (fst_p, X.ContainerPair.fst c)))
            ,  (fn snd_p =>  Option.map X.BaseSum.snd_inj (X.SndPT.select (snd_p, X.ContainerPair.snd c))) )
               p

   end;
