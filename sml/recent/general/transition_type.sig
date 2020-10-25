signature TransitionType =
   sig

      type base_t

      type T

      val next:             T -> (base_t * T) Option.option
      val transition:       (base_t * (unit -> 'b) -> 'b) -> T -> 'b -> 'b

   end;
