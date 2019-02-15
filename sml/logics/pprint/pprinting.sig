use "logics/pprint/pprintable.sig";

signature PPrintPPrinting =
   sig
      structure PPrintPPrintable: PPrintPPrintable
      val pprint: TextIO.outstream * PPrintPPrintable.T * int -> PPrintPPrintable.PPrintIndentBase.indent * PPrintPPrintable.PPrintIndentBase.state -> PPrintPPrintable.PPrintIndentBase.state
   end;
