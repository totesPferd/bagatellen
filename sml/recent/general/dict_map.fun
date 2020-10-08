use "general/dict_map.sig";
use "general/dict_set.fun";
use "general/eq_type.sig";

functor DictMap(X:
   sig

      structure I: DictSet

      structure From: Dict
      structure To: Dict

   end): DictMap =
   struct
 
      structure From =  X.From
      structure To   =  X.To

      val map =  X.I.Dicts.map

   end
