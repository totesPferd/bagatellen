use "general/dict_set.fun";
use "general/dict.sig";
use "general/eq_type.sig";

functor Dict(X:
   sig

      structure K: EqType
      type val_t

      structure I: DictSet
      sharing I.E = K

   end ): Dict =
   struct

      type key_t =  X.K.T
      type val_t =  X.val_t

      type T =  X.val_t X.I.Dicts.dict

      val adjoin    =  X.I.Dicts.adjoin
      val all       =  X.I.Dicts.all
      val deref     =  X.I.Dicts.deref
      val empty     =  X.I.Dicts.empty
      val set       =  X.I.Dicts.set
      val singleton =  X.I.Dicts.singleton

   end
