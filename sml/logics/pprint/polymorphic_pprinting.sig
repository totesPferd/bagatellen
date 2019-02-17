use "collections/type.sig";
use "logics/pprint/indent_base.sig";

signature PPrintPolymorphicPPrinting =
   sig
      structure PPrintIndentBase: PPrintIndentBase
      structure ContextType: Type
      val pprint:
            (ContextType.T -> 'a -> string)
         -> (ContextType.T -> TextIO.outstream * 'a * int -> PPrintIndentBase.indent * PPrintIndentBase.state -> PPrintIndentBase.state)
         -> ContextType.T
         -> TextIO.outstream * 'a * int
         -> PPrintIndentBase.indent * PPrintIndentBase.state
         -> PPrintIndentBase.state
   end;
