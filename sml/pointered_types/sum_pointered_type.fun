use "general/sum_type.sig";
use "pointered_types/pointered_type.sig";

functor SumPointeredType(X:
   sig
      structure FstPT: PointeredType
      structure SndPT: PointeredType
      structure BaseSum: SumType
      structure PointerSum: SumType
      sharing FstPT.BaseType = BaseSum.FstType
      sharing SndPT.BaseType = BaseSum.SndType
      sharing FstPT.PointerType = PointerSum.FstType
      sharing SndPT.PointerType = PointerSum.SndType
   end ): PointeredType =
   struct
      structure BaseType =  X.BaseSum
      structure ContainerType =
         struct
            type T =  X.FstPT.ContainerType.T * X.SndPT.ContainerType.T
         end
      structure PointerType =  X.PointerSum

      val empty =  (X.FstPT.empty, X.SndPT.empty)
      fun is_empty (c_1, c_2)
         =  (X.FstPT.is_empty c_1) andalso (X.SndPT.is_empty c_2)

      fun select (p, (c_1, c_2))
         =  X.PointerSum.traverse (
               (fn fst_p =>  Option.map X.BaseSum.fst_inj (X.FstPT.select (fst_p, c_1)))
            ,  (fn snd_p =>  Option.map X.BaseSum.snd_inj (X.SndPT.select (snd_p, c_2))) )
               p

      exception undefined_singleton
      fun singleton(p, b)
         =  X.PointerSum.traverse (
               (fn fst_p
               => X.BaseSum.traverse (
                     (fn fst_b =>  (X.FstPT.singleton(fst_p, fst_b), X.SndPT.empty))
                  ,  (fn snd_b =>  raise undefined_singleton) )
                     b )
            ,  (fn snd_p
               => X.BaseSum.traverse (
                     (fn fst_b =>  raise undefined_singleton)
                  ,  (fn snd_b =>  (X.FstPT.empty, X.SndPT.singleton(snd_p, snd_b))) )
                     b ))
               p
   end;
