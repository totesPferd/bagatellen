use "general/eqs.sig";
use "collections/sum_type.sig";

functor SumType(X:
   sig
      structure T_A: Eqs
      structure T_B: Eqs
   end ): SumType =
   struct
      structure T_A =  X.T_A
      structure T_B =  X.T_B
      datatype T =  ChooseA of T_A.T | ChooseB of T_B.T
      fun eq (ChooseA a_1, ChooseA a_2) =  T_A.eq(a_1, a_2)
      |   eq (ChooseA a_1, ChooseB b_2) =  false
      |   eq (ChooseB b_1, ChooseA a_2) =  false
      |   eq (ChooseB b_1, ChooseB b_2) =  T_B.eq(b_1, b_2)
      val inj_a =  ChooseA
      val inj_b =  ChooseB
      fun traverse (fn_a, fn_b) (ChooseA a) =  fn_a a
      |   traverse (fn_a, fn_b) (ChooseB b) =  fn_b b
   end;
