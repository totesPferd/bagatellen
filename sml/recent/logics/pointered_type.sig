signature PointeredType =
   sig
      type base_t
      type container_t
      type pointer_t

      val empty:    container_t
      val is_empty: container_t -> bool
      val select:   pointer_t * container_t -> base_t Option.option
   end;
