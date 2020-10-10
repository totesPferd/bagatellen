signature PPrintBase =
   sig
      type state

(* Call it first when using this structure !  In order to get the initial state. *)
      val init:              state

(* Call it to get deeper indent from the next line on. *)
      val set_deeper_indent: state -> state

(* Call it to restore indent from deeper one. *)
      val restore_indent:    state -> state

(* Next call of print_par will preceed a leading white space. *)
      val force_ws:          state -> state

(* Set cursor to beginning of a new line. *)
      val print_nl:          TextIO.outstream -> state -> state

(* Use it to place an opening parenthesis like ( [ {. *)
      val print_open_par:    TextIO.outstream * string -> state -> state

(* Use it to place a closing parenthesis like ) ] } or also signs as , ;. *)
      val print_close_par:   TextIO.outstream * string -> state -> state

(* Use it to place white space like spaces, tabs. *)
      val print_ws:          TextIO.outstream * string -> state -> state

(* Use it to place a token.  Also use it for placing binary operational sign as + - * / == <> etc.  Insert white spaces if necessary. *)
      val print_tok:         TextIO.outstream * string -> state -> state

(* Use it to place an assignment token as := or =.  Insert white spaces if necessary. *)
      val print_assign:      TextIO.outstream * string -> state -> state

(* Use it to place period which ends sentences, i.e. . ! ? .  Insert white spaces if necessary. *)
      val print_period:      TextIO.outstream * string -> state -> state

(* Place the cursor to the given column. *)
      val navigate_to_pos:   TextIO.outstream * int -> state -> state

   end;
