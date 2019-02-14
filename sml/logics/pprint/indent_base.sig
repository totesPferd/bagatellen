signature PPrintIndentBase =
   sig
      type indent
      type state

      val init:              indent * state
      val force_ws:          state -> state
      val get_deeper_indent: indent -> indent
      val print_nl:          TextIO.outstream -> state -> state
      val print_par:         TextIO.outstream * string -> state -> state
      val print_ws:          TextIO.outstream * string -> state -> state
      val print:             TextIO.outstream * string -> state -> state
      val navigate_to_pos:   TextIO.outstream * int -> indent * state -> state
   end;
