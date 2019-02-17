use "collections/type.sig";
use "logics/pprint/indent_base.sig";

signature PPrintContext =
   sig
      structure ContextType: Type
      structure PPrintIndentBase: PPrintIndentBase

      val multi_line: ContextType.T -> TextIO.outstream -> PPrintIndentBase.indent * PPrintIndentBase.state -> PPrintIndentBase.state
   end;
