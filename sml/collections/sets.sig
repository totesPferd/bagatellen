use "collections/eqs.sig";

signature Sets =
   sig
      structure Eqs: Eqs

      type T

      val empty:           T
      val map:             (Eqs.T -> Eqs.T) -> T -> T
      val singleton:       Eqs.T -> T
      val drop:            Eqs.T * T -> T
      val drop_if_exists:  Eqs.T * T -> T Option.option
      val insert:          Eqs.T * T -> T
      val cut:             T * T -> T
      val union:           T * T -> T

      val is_member:       Eqs.T * T -> bool
      val is_empty:        T -> bool
      val subseteq:        T * T -> bool
      val eq:              T * T -> bool

      val find:            (Eqs.T -> bool) -> T -> Eqs.T Option.option

      val transition:      (Eqs.T * 'b -> 'b Option.option) -> T -> 'b -> 'b
   end;
