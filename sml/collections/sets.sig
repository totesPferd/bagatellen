use "collections/eqs.sig";

signature Sets =
   sig
      structure Eqs: Eqs

      type T

      val empty:           T
      val map:             (Eqs.Type.T -> Eqs.Type.T) -> T -> T
      val singleton:       Eqs.Type.T -> T
      val drop:            Eqs.Type.T * T -> T
      val drop_if_exists:  Eqs.Type.T * T -> T Option.option
      val insert:          Eqs.Type.T * T -> T
      val cut:             T * T -> T
      val union:           T * T -> T

      val is_member:       Eqs.Type.T * T -> bool
      val is_empty:        T -> bool
      val subseteq:        T * T -> bool

      val pmap:            (Eqs.Type.T -> Eqs.Type.T Option.option) -> T -> T Option.option
   end;
