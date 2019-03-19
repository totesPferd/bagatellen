use "general/eqs.sig";

signature Variables =
   sig
      structure Base:
         sig
            structure Single: Eqs
         end
      type T
      val new:         T
      val eq:          T * T -> bool
      val copy:        T -> T
      val get_val:     T -> Base.Single.T Option.option
      val is_bound:    T -> bool
      val is_settable: T -> bool
      val set_val:     Base.Single.T -> T -> bool

   end;
