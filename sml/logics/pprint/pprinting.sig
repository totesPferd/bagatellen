use "logics/pprint/base.sig";

signature PPrintPPrintable =
   sig
      structure PPrintBase: PPrintBase
      type T
      val pprint: TextIO.outstream * T * int -> PPrintBase.state -> PPrintBase.state
   end;
