signature PPrintBase =
   sig
      type state

      val init:            state
      val print_nl:        TextIO.outstream -> state -> state
      val print:           TextIO.outstream * string * bool -> state -> state
      val navigate_to_pos: TextIO.outstream * int -> state -> state
   end;
