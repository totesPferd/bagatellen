use "logics/pprint/pprintable.sig";

signature PPrintPPrintable =
   sig
      structure PPrintPPrintable: PPrintPPrintable
      val pprint: TextIO.outstream * PPrintPPrintable.T * int -> PPrintPPrintable.PPrintBase.state -> PPrintPPrintable.PPrintBase.state
   end;
