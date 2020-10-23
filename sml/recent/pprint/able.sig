signature PPrintAble =
   sig

      type context_t
      type state_t

      type T

      val pprint: TextIO.outstream * context_t * T -> state_t -> unit

   end;
