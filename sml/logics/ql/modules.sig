signature Modules =
   sig
      type T

      val new: unit -> T
      val eq: T * T -> bool

   end;
