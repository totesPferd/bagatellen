use "collections/type.sig";
use "logics/pprint/indent_base.sig";
use "logics/pprint/pprintable.sig";

signature PPrintPPrintableLiterals =
   sig
      structure ContextType: Type
      structure PPrintIndentBase: PPrintIndentBase
      structure Single: PPrintPPrintable
      structure Multi: PPrintPPrintable
      sharing Single.ContextType = ContextType
      sharing Multi.ContextType = ContextType
      sharing Single.PPrintIndentBase =  PPrintIndentBase
      sharing Multi.PPrintIndentBase =  PPrintIndentBase
   end;
