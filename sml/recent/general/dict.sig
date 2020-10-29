signature Dict =
  sig
      type key_t
      type val_t
      type T

      val adjoin:           T * T -> T
      val all:              (val_t -> bool) -> T -> bool
      val deref:            key_t * T -> val_t Option.option
      val empty:            T
      val set:              key_t * val_t * T -> T
      val singleton:        key_t * val_t -> T

      val foldl:            (key_t * val_t * 'b -> 'b) -> 'b -> T -> 'b
   end

