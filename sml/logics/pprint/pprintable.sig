use "general/type.sig";
use "logics/pprint/indent_base.sig";

signature PPrintPPrintable =
   sig
      structure ContextType: Type
      structure PPrintIndentBase: PPrintIndentBase
      type T

      val single_line: ContextType.T -> T -> string
      val multi_line: ContextType.T -> TextIO.outstream * T * int -> PPrintIndentBase.indent * PPrintIndentBase.state -> PPrintIndentBase.state
   end;
