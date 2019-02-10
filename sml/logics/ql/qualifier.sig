signature Qualifier =
   sig
      type T

      val new_anonymous: unit -> T
      val new: string -> T
      val get_name: T -> string Option.option
      val eq: T * T -> bool

   end;
