signature StringType =
   sig
      type T
      val point: string -> T
      val eq: T * T -> bool
   end;
