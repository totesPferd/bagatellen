use "collections/dictset.sig";

signature Occurences =
   sig
      structure DictSet: DictSet

      type T

      val get_multiple_occurences: T -> DictSet.Sets.T
      val get_occurences:          T -> DictSet.Sets.T

      val empty:                   T
      val singleton:               DictSet.Eqs.T -> T
      val unif_occurences:         T * T -> T

   end;
