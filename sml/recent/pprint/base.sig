(* Sample use:

   use "general/string_utils.sig";
   use "pprint/base.fun";
   use "pprint/config.sig";
   
   structure MyConfig: PPrintConfig =
      struct
         type config = {indent: int, page_width: int}
         val config =  { indent = 3, page_width = 72 }
      end;
   
   structure MyPrintBase =  PPrintBase(
      struct
         structure Config =  MyConfig
         structure StringUtils =  StringUtils
      end )

   val state =  MyPrintBase.init;
   
   (
      MyPrintBase.print_tok (TextIO.stdOut, "Hello") state;
      MyPrintBase.print_close_par (TextIO.stdOut, ",") state;
      MyPrintBase.print_tok (TextIO.stdOut, "World") state;
      MyPrintBase.print_period (TextIO.stdOut, "!") state;
      MyPrintBase.print_tok (TextIO.stdOut, "Ciao") state;
      MyPrintBase.print_period (TextIO.stdOut, "!") state;
      MyPrintBase.print_ws (TextIO.stdOut, " ") state;
      MyPrintBase.print_open_par (TextIO.stdOut, "(") state;
      MyPrintBase.print_open_par (TextIO.stdOut, "(") state;
      MyPrintBase.print_tok (TextIO.stdOut, "inside pars") state;
      MyPrintBase.print_close_par (TextIO.stdOut, ")") state;
      MyPrintBase.print_close_par (TextIO.stdOut, ")") state;
      MyPrintBase.force_ws state;
      MyPrintBase.print_close_par (TextIO.stdOut, ")") state;
      MyPrintBase.print_tok (TextIO.stdOut, "after all the pars") state;
   
      MyPrintBase.navigate_to_pos (TextIO.stdOut, 30) state;
      MyPrintBase.print_tok (TextIO.stdOut, "Hello world!") state;
      MyPrintBase.print_nl TextIO.stdOut state;
   
      MyPrintBase.set_deeper_indent state;
      MyPrintBase.print_tok(TextIO.stdOut, "Hello world!") state;
      MyPrintBase.print_nl TextIO.stdOut state;
      MyPrintBase.print_tok(TextIO.stdOut, "Once again:  Hello world!") state;
      MyPrintBase.set_deeper_indent state;
      MyPrintBase.print_nl TextIO.stdOut state;
      MyPrintBase.print_tok(TextIO.stdOut, "Once again:  Hello world!") state;
      MyPrintBase.print_nl TextIO.stdOut state;
      MyPrintBase.print_tok(TextIO.stdOut, "Once again:  Hello world!") state;
      MyPrintBase.restore_indent state;
      MyPrintBase.print_nl TextIO.stdOut state;
      MyPrintBase.print_tok(TextIO.stdOut, "Once again:  Hello world!") state;
      MyPrintBase.print_nl TextIO.stdOut state;
      MyPrintBase.print_tok(TextIO.stdOut, "Once again:  Hello world!") state;
      MyPrintBase.set_deeper_indent state;
      MyPrintBase.print_nl TextIO.stdOut state;
      MyPrintBase.print_tok(TextIO.stdOut, "Once again:  Hello world!") state;
      MyPrintBase.restore_indent state;
      MyPrintBase.restore_indent state;
      MyPrintBase.print_nl TextIO.stdOut state;
      MyPrintBase.print_tok(TextIO.stdOut, "Once again:  Hello world!") state;
      MyPrintBase.print_nl TextIO.stdOut state );

*)



signature PPrintBase =
   sig
      type state

(* Call it first when using this structure !  In order to get the initial state. *)
      val init:                      state

(* Call it to get deeper indent from the next line on. *)
      val set_deeper_indent:         state -> unit

(* Call it to restore indent from deeper one. *)
      val restore_indent:            state -> unit

(* Next call of print_close_par will preceed a leading white space. *)
      val force_ws:                  state -> unit

(* Set cursor to beginning of a new line. *)
      val print_nl:                  TextIO.outstream -> state -> unit

(* Use it to place an opening parenthesis like ( [ {. *)
      val print_open_par:            TextIO.outstream * string -> state -> unit

(* Use it to place a closing parenthesis like ) ] } or also signs as , ;. *)
      val print_close_par:           TextIO.outstream * string -> state -> unit

(* Use it to place white space like spaces, tabs. *)
      val print_ws:                  TextIO.outstream * string -> state -> unit

(* Use it to place a token.  Also use it for placing binary operational sign as + - * / == <> etc.  This procedure will insert white spaces if necessary. *)
      val print_tok:                 TextIO.outstream * string -> state -> unit

(* Use it to place an assignment token as := or =.  This procedure will insert white spaces if necessary. *)
      val print_assign:              TextIO.outstream * string -> state -> unit

(* Use it to place period which ends sentences, i.e. . ! ? .  This procedure will insert white spaces if necessary. *)
      val print_period:              TextIO.outstream * string -> state -> unit

(* Place the cursor to the given column. *)
      val navigate_to_pos:           TextIO.outstream * int -> state -> unit

(* Place the cursor to the given column relative to the indent. *)
      val navigate_to_rel_pos:       TextIO.outstream * int -> state -> unit

(* yields remaining width on line after indent. *)
      val get_remaining_line_width:  state -> int

   end;
