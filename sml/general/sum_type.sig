use "general/eqs.sig";

signature SumType =
   sig
      structure FstType: Eqs
      structure SndType: Eqs
      type T
      val eq: T * T -> bool
      val fst_inj: FstType.T -> T
      val snd_inj: SndType.T -> T
      val traverse: (FstType.T -> 'a) * (SndType.T -> 'a) -> T -> 'a
   end;
