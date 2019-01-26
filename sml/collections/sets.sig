use "collections/eqs.sig";

signature Sets =
   sig
      structure Eqs: Eqs

      type T

      val empty:     T
      val map:       (Eqs.T -> Eqs.T) -> T -> T
      val singleton: Eqs.T -> T
      val drop:      Eqs.T * T -> T
      val insert:    Eqs.T * T -> T
      val cut:       T * T -> T
      val union:     T * T -> T

      val is_member:  Eqs.T * T -> bool
      val subseteq:   T * T -> bool
   end;
