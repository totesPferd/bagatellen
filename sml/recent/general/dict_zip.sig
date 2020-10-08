use "general/dict.sig";

signature DictZip =
   sig
      structure DictA: Dict
      structure DictB: Dict
         where type key_t =  DictA.key_t
      structure DictResult: Dict
         where type key_t =  DictA.key_t
         and   type val_t =  DictA.val_t * DictB.val_t

      val zip: DictA.T * DictB.T -> DictResult.T
   end;
