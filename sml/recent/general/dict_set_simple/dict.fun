use "general/dict_set_simple/dict_impl.sig";
use "general/eq_type.sig";

functor DictSetSimpleDict(X:
   sig
      structure K: EqType
      type val_t
   end ): DictSetSimpleDictImpl =
   struct

      type key_t =  X.K.T
      type val_t =  X.val_t
      type T =  { key: key_t, value: val_t } list
      val empty =  nil
      fun deref(k, d: T) =  Option.map (#value) (List.find (fn a => X.K.eq(k, #key a)) d)
      fun set(k, v, nil) =  [ { key = k, value = v } ]
        | set(k, v, a :: (d: T))
         = if  X.K.eq(k, #key a)
           then
              a :: d
           else
              a :: set(k, v, d)
      fun all P = List.all (fn { key = _, value = v } => P v)
      fun adjoin(d_1, d_2) =  d_1 @ d_2
      fun singleton(k, v) =  [ { key = k, value = v } ]

   end
   
