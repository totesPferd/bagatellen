use "collections/type.sig";

signature Variables =
   sig
      structure Base: Type
      type T
      val new:      T
      val eq:       T * T -> bool
      val copy:     T -> T
      val get_val:  T -> Base.T Option.option
      val is_bound: T -> bool
   end;
