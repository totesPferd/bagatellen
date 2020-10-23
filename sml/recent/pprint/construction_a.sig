signature PPrintConstructionA =
   sig

      type context_t
      type state_t

      type T

      val single_line: context_t * T -> string
      val multi_line: TextIO.outstream * context_t * T -> state_t -> unit

   end;
