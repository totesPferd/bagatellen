use "general/dict.sig";

signature DictZip =
   sig
      structure DictA: Dict
      structure DictB: Dict
      structure DictResult: Dict
         where type key_t =  DictA.key_t * DictB.key_t

      val zip: DictA.T * DictB.T -> DictResult.T
   end;
