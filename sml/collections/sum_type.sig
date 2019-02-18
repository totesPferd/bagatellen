use "collections/eqs.sig";

signature SumType =
   sig
      structure T_A: Eqs
      structure T_B: Eqs
      type T
      val eq: T * T -> bool
      val inj_a: T_A.T -> T
      val inj_b: T_B.T -> T
      val traverse: (T_A.T -> 'a) * (T_B.T -> 'a) -> T -> 'a
   end;
