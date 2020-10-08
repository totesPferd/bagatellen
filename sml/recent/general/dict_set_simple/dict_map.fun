use "general/dict_map.sig";
use "general/dict_set_simple/dict_impl.sig";

functor DictSetSimpleDictMap(X:
   sig
      structure From: DictSetSimpleDictImpl
      structure To: DictSetSimpleDictImpl
         where type key_t = From.key_t
   end ): DictMap =
   struct

      structure From =  X.From
      structure To =  X.To

      fun map (f: From.val_t -> To.val_t) (d: From.T) =  List.map (fn a => { key = #key a, value = f(#value a) }) d

   end
