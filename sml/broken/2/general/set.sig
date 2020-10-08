signature Set =
   sig
      type base_t
      type T
      val adjunct:          base_t * T -> T
      val cut:              T * T -> T
      val drop:             base_t * T -> T
      val drop_if_exists:   base_t * T -> T Option.option
      val empty:            T
      val eq:               T * T -> bool
      val getItem:          T -> (base_t * T) Option.option
      val insert:           base_t * T -> T
      val intersect:        T * T -> T
      val is_empty:         T -> bool
      val map:              (base_t -> base_t) -> T -> T
      val singleton:        base_t -> T
      val subseteq:         T * T -> bool
      val sum:              T * T -> T
      val union:            T * T -> T

      val find:             (base_t -> bool) -> T -> base_t Option.option

      val ofind:            (base_t -> 'b Option.option) -> T -> 'b Option.option

      val fe:               base_t -> T
      val fop:              (base_t -> T) -> T -> T
      val is_in:            base_t * T -> bool
      val transition:       (base_t * 'b -> 'b Option.option) -> T -> 'b -> 'b
   end

