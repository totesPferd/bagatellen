use "logics/pprint/pprintable.sig";

signature PPrintPPrinting =
   sig
      structure PPrintPPrintable: PPrintPPrintable
      val pprint:
            PPrintPPrintable.ContextType.T
         -> TextIO.outstream * PPrintPPrintable.T * int
         -> PPrintPPrintable.PPrintIndentBase.indent * PPrintPPrintable.PPrintIndentBase.state
         -> PPrintPPrintable.PPrintIndentBase.state
   end;
