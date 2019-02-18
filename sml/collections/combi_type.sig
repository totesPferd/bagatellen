signature CombiType =
   sig
      type T
      val use_npt: string -> T
      val use_upt: T
      val traverse:  (string -> 'a) * (unit -> 'a) -> T -> 'a
      val eq:  T * T -> bool
   end;
