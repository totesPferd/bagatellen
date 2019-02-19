use "general/type.sig";
use "logics/pprint/delim_config.sig";
use "logics/pprint/indent_base.sig";

signature PPrintPolymorphicSetalikes =
   sig
      structure PPrintDelimConfig: PPrintDelimConfig
      structure ContextType: Type
      structure PPrintIndentBase: PPrintIndentBase

      val single_line:
            (('s * string -> string Option.option) -> 'm -> string -> string)
         -> (ContextType.T -> 's -> string)
         -> ContextType.T
         -> 'm
         -> string
      val multi_line:
            (     ('s * ('s Option.option * PPrintIndentBase.state) -> ('s Option.option * PPrintIndentBase.state) Option.option)
               -> 'm
               -> 's Option.option * PPrintIndentBase.state
               -> 's Option.option * PPrintIndentBase.state )
         -> (     ContextType.T
               -> TextIO.outstream * 's * int
               -> PPrintIndentBase.indent * PPrintIndentBase.state
               -> PPrintIndentBase.state )
         -> ContextType.T
         -> TextIO.outstream * 'm * int
         -> PPrintIndentBase.indent * PPrintIndentBase.state
         -> PPrintIndentBase.state
   end;
