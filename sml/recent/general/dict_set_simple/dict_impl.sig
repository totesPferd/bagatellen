signature DictSetSimpleDictImpl =
  sig
      type key_t
      type val_t
      type T  =  { key: key_t, value: val_t } list

      val adjoin:           T * T -> T
      val all:              (val_t -> bool) -> T -> bool
      val deref:            key_t * T -> val_t Option.option
      val empty:            T
      val set:              key_t * val_t * T -> T
      val singleton:        key_t * val_t -> T
   end

