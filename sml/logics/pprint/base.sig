signature PPrintBase =
   sig
      type state

      val init:            state
      val print_par:       TextIO.outstream * string -> state -> state
      val print_nl:        TextIO.outstream -> state -> state
      val print_ws:        TextIO.outstream * string -> state -> state
      val print:           TextIO.outstream * string -> state -> state
      val navigate_to_pos: TextIO.outstream * int -> state -> state
   end;
