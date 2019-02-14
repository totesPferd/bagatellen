use "logics/pprint/indent_base.sig";

signature PPrintPPrintable =
   sig
      structure PPrintIndentBase: PPrintIndentBase
      type T

      val single_line: T -> string
      val multi_line: TextIO.outstream * T -> PPrintIndentBase.indent * PPrintIndentBase.state -> PPrintIndentBase.state
   end;
