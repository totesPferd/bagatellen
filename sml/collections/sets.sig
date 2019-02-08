use "collections/eqs.sig";

signature Sets =
   sig
      structure Eqs: Eqs

      type T

      val empty:           T
      val getItem :        T -> (Eqs.T * T) Option.option
      val map:             (Eqs.T -> Eqs.T) -> T -> T
      val singleton:       Eqs.T -> T
      val adjunct:         Eqs.T * T -> T
      val drop:            Eqs.T * T -> T
      val drop_if_exists:  Eqs.T * T -> T Option.option
      val insert:          Eqs.T * T -> T
      val sum:             T * T -> T
      val cut:             T * T -> T
      val union:           T * T -> T
      val intersect:       T * T -> T

      val is_in    :       Eqs.T * T -> bool
      val is_empty:        T -> bool
      val subseteq:        T * T -> bool
      val eq:              T * T -> bool

      val find:            (Eqs.T -> bool) -> T -> Eqs.T Option.option

      val ofind:           (Eqs.T -> 'b Option.option) -> T -> 'b Option.option

      val fe:              Eqs.T -> T
      val fop:             (Eqs.T -> T) -> T -> T
      val transition:      (Eqs.T * 'b -> 'b Option.option) -> T -> 'b -> 'b
   end;
