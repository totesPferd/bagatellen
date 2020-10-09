use "general/pprint/base.fun";
use "general/pprint/config.sig";

structure MyConfig: PPrintConfig =
   struct
      type config = {indent: int, page_width: int}
      val config =  { indent = 3, page_width = 72 }
   end;

structure MyPrintBase =  PPrintBase(MyConfig)

val state =  ref MyPrintBase.init;

(
   state := MyPrintBase.print_tok (TextIO.stdOut, "Hallo") (!state);
   state := MyPrintBase.print_par (TextIO.stdOut, ",") (!state);
   state := MyPrintBase.print_tok (TextIO.stdOut, "Welt") (!state);
   state := MyPrintBase.print_period (TextIO.stdOut, "!") (!state);
   state := MyPrintBase.print_ws (TextIO.stdOut, " ") (!state);
   state := MyPrintBase.print_par (TextIO.stdOut, "(") (!state);
   state := MyPrintBase.print_par (TextIO.stdOut, "(") (!state);
   state := MyPrintBase.print_tok (TextIO.stdOut, "Daett faetzt!") (!state);
   state := MyPrintBase.print_par (TextIO.stdOut, ")") (!state);
   state := MyPrintBase.print_par (TextIO.stdOut, ")") (!state);
   state := MyPrintBase.force_ws (!state);
   state := MyPrintBase.print_par (TextIO.stdOut, ")") (!state);
   state := MyPrintBase.print_tok (TextIO.stdOut, "KlammernZuende") (!state);
   state := MyPrintBase.navigate_to_pos (TextIO.stdOut, 30) (!state);
   state := MyPrintBase.print_tok (TextIO.stdOut, "Welt") (!state);
   state := MyPrintBase.print_nl(TextIO.stdOut) (!state) );

state
