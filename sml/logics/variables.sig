signature Variables =
   sig
      type Base
      type T
      val new:      T
      val eq:       T * T -> bool
      val copy:     T -> T
      val get_val:  T -> Base Option.option
      val is_bound: T -> bool
   end;
