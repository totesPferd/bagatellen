use "collections/dictset.sig";

signature Occurences =
   sig
      structure DictSet: DictSet

      type occurences =  {
            multiple_occ: DictSet.Sets.T
         ,  occ: DictSet.Sets.T }

      val unif_occurences: occurences * occurences -> occurences

   end;
