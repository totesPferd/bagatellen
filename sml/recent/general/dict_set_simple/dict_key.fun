use "general/dict_keys.sig";
use "general/dict_set_simple/dict_impl.sig";
use "general/dict_set_simple/set_impl.sig";

functor DictSetSimpleDictKeys(X:
   sig
      structure D: DictSetSimpleDictImpl
      structure S: DictSetSimpleSetImpl
         where type base_t = D.key_t
   end ): DictKeys =
   struct
      structure From =  X.D
      structure To =  X.S

      fun keys (d: X.D.T) =  (List.map #key d): X.S.T
   end
