use "logics/pprint/pprintable.sig";

signature PPrintPPrinting =
   sig
      structure PPrintPPrintable: PPrintPPrintable
      val pprint: TextIO.outstream * PPrintPPrintable.T * int -> PPrintPPrintable.PPrintBase.state -> PPrintPPrintable.PPrintBase.state
   end;
