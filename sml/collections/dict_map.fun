use "collections/dict_map.sig";
use "collections/dictset.sig";
use "general/type.sig";

functor DictMap(X:
   sig
      structure DS: DictSet
      structure End: Type
   end ): DictMap =
   struct
      structure DictSet =  X.DS

      structure Start =  DictSet.Eqs
      structure End =  X.End

      type T =  End.T DictSet.Dicts.dict

      fun apply f x
         =  Option.valOf (DictSet.Dicts.deref(x, f))

   end;
