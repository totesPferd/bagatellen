use "logics/pprint/base.sig";

signature PPrintPPrintable =
   sig
      structure PPrintBase: PPrintBase
      type T

      val single_line: T -> string
      val multi_line: TextIO.outstream * T -> PPrintBase.state -> PPrintBase.state
   end;
