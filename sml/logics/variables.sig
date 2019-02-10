signature Variables =
   sig
      type Base
      type T
      val new:  unit -> T
      val eq:   T * T -> bool
      val copy: T -> T
   end;
