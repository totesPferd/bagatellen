(*
  Example use:

structure MyConfig: PPrintConfig =
   struct
      type config = { indent: int, page_width: int }
      val config =  { indent = 3, page_width = 72 }
   end;

structure MyPrintBase =  PPrintBase(MyConfig)

val state =  ref MyPrintBase.init;

(
   state := MyPrintBase.print_tok (TextIO.stdOut, "Hello") (!state);
   state := MyPrintBase.print_close_par (TextIO.stdOut, ",") (!state);
   state := MyPrintBase.print_tok (TextIO.stdOut, "World!") (!state);
   state := MyPrintBase.print_ws (TextIO.stdOut, " ") (!state);
   state := MyPrintBase.print_open_par (TextIO.stdOut, "(") (!state);
   state := MyPrintBase.print_open_par (TextIO.stdOut, "(") (!state);
   state := MyPrintBase.print_tok (TextIO.stdOut, "inside parenthesises") (!state);
   state := MyPrintBase.print_close_par (TextIO.stdOut, ")") (!state);
   state := MyPrintBase.print_close_par (TextIO.stdOut, ")") (!state);
   state := MyPrintBase.force_ws (!state);
   state := MyPrintBase.print_close_par (TextIO.stdOut, ")") (!state);
   state := MyPrintBase.print_tok (TextIO.stdOut, "at the end of all parenthesises") (!state);
   state := MyPrintBase.navigate_to_pos (TextIO.stdOut, 30) (!state);
   state := MyPrintBase.print_tok (TextIO.stdOut, "after setting to a new cursor position") (!state);
   state := MyPrintBase.print_nl(TextIO.stdOut) (!state) );

)

*)
  

signature PPrintBase =
   sig
      type state

(* Call it first when using this structure !  In order to get the initial state. *)
      val init:            state

(* Next call of print_par will preceed a leading white space. *)
      val force_ws:        state -> state

(* Set cursor to beginning of a new line. *)
      val print_nl:        TextIO.outstream -> state -> state

(* Use it to place an opening parenthesis like ( [ {. *)
      val print_open_par:  TextIO.outstream * string -> state -> state

(* Use it to place a closing parenthesis like ) ] } or also signs as , ;. *)
      val print_close_par: TextIO.outstream * string -> state -> state

(* Use it to place white space like spaces, tabs. *)
      val print_ws:        TextIO.outstream * string -> state -> state

(* Use it to place a token. Also use it for placing binary operational sign as + - * / == <> etc. Insert white spaces if necessary. *)
      val print_tok:       TextIO.outstream * string -> state -> state

(* Use it to place an assignment token as := or =.  Insert white spaces if necessary. *)
      val print_assign:    TextIO.outstream * string -> state -> state

(* Use it to place period which ends sentences, i.e. . ! ? .  Insert white spaces if necessary. *)
      val print_period:    TextIO.outstream * string -> state -> state

(* Place the cursor to the given column. *)
      val navigate_to_pos: TextIO.outstream * int -> state -> state

   end;
