use "general/dict.sig";
use "general/set.sig";

signature DictKeys =
   sig
      structure From: Dict
      structure To: Set
         where type base_t =  From.key_t

      val keys: From.T -> To.T
   end
