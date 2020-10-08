use "general/eqs.sig";
use "general/sum_type.sig";

functor SumType(X:
   sig
      structure FstType: Eqs
      structure SndType: Eqs
   end ): SumType =
   struct
      structure FstType =  X.FstType
      structure SndType =  X.SndType
      datatype T =  ChooseA of FstType.T | ChooseB of SndType.T
      fun eq (ChooseA a_1, ChooseA a_2) =  FstType.eq(a_1, a_2)
      |   eq (ChooseA a_1, ChooseB b_2) =  false
      |   eq (ChooseB b_1, ChooseA a_2) =  false
      |   eq (ChooseB b_1, ChooseB b_2) =  SndType.eq(b_1, b_2)
      val fst_inj =  ChooseA
      val snd_inj =  ChooseB
      fun traverse (fn_a, fn_b) (ChooseA a) =  fn_a a
      |   traverse (fn_a, fn_b) (ChooseB b) =  fn_b b
   end;
