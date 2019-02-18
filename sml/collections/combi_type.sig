signature CombiType =
   sig
      type T
      val point_npt: string -> T
      val point_upt: T
      val traverse:  (string -> 'a) * (unit -> 'a) -> T -> 'a
      val eq:  T * T -> bool
   end;
