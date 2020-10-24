signature TransitionType =
   sig

      type base_t

      type T

      val transition:       (base_t * 'b -> 'b Option.option) -> T -> 'b -> 'b

   end;
