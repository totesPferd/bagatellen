use "general/type.sig";

signature PairType =
   sig
      structure FstType: Type
      structure SndType: Type

      type T

      val fst: T -> FstType.T
      val snd: T -> SndType.T
      val tuple: FstType.T * SndType.T -> T

   end;
