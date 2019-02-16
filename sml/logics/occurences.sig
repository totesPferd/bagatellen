use "collections/dictset.sig";

signature Occurences =
   sig
      structure DictSet: DictSet

      type occurences

      val get_multiple_occurences: occurences -> DictSet.Sets.T
      val get_occurences: occurences -> DictSet.Sets.T

      val empty: occurences
      val singleton: DictSet.Eqs.T -> occurences
      val unif_occurences: occurences * occurences -> occurences

   end;
