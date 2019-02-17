use "collections/naming_pointered_type.sig";
use "collections/type.sig";
use "logics/literals.sig";
use "logics/pprint/indent_base.sig";
use "logics/pprint/pprintable.sig";
use "logics/variable_contexts.sig";

signature PPrintPPrintableLiterals =
   sig
      structure ContextType: Type
      structure Literals: Literals
      structure NamingPointeredType: NamingPointeredType
      structure PPrintIndentBase: PPrintIndentBase
      structure VariableContexts: VariableContexts
      structure Variables: Variables
      structure Single: PPrintPPrintable
      structure Multi: PPrintPPrintable
      sharing Single.ContextType = ContextType
      sharing Multi.ContextType = ContextType
      sharing Single.PPrintIndentBase =  PPrintIndentBase
      sharing Multi.PPrintIndentBase =  PPrintIndentBase
      sharing NamingPointeredType.PointeredType.BaseType = VariableContexts.Variables
      sharing NamingPointeredType.PointeredType = VariableContexts.PointeredType
      sharing Literals.Single =  Single
      sharing Literals.Variables =  Variables
      sharing VariableContexts.VariableContext =  ContextType
      sharing VariableContexts.Variables =  Variables

   end;
