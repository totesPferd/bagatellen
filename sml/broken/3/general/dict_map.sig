use "general/dict.sig";

signature DictMap =
   sig
      structure From: Dict
      structure To: Dict

      val map: (From.val_t -> To.val_t) -> From.T -> To.T
   end
