signature PELNamedType =
   sig

      type base_t
      val eq: base_t * base_t -> bool

      type container_t

      val get_name: base_t -> container_t -> string Option.option
      val set_name: string * base_t -> container_t -> bool

      val is_in: base_t * container_t -> bool
      val subeq: container_t * container_t -> bool

      val insert: (string Option.option ref * base_t) * container_t -> container_t
      val sum: container_t * container_t -> container_t
      val union: container_t * container_t -> container_t

      val uniquize: container_t -> unit

   end;
