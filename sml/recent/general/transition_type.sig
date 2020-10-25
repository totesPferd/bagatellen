signature TransitionType =
   sig

      type base_t

      type T

      val transition:       (base_t * (unit -> 'b) -> 'b) -> T -> 'b -> 'b

   end;
