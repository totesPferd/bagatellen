signature Variables =
   sig
      type T
      val eq:   T * T -> bool
      val copy: T -> T
   end;
