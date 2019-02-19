use "collections/naming_pointered_type_extension.sig";
use "general/type.sig";
use "logics/literals.sig";
use "logics/pprint/indent_base.sig";
use "logics/pprint/pprintable.sig";
use "logics/variable_contexts.sig";

signature PPrintPPrintableLiterals =
   sig
      structure ContextType: Type
      structure Literals: Literals
      structure NamingPointeredTypeExtension: NamingPointeredTypeExtension
      structure PPrintIndentBase: PPrintIndentBase
      structure VariableContexts: VariableContexts
      structure Variables: Variables
      structure Single: PPrintPPrintable
      structure Multi: PPrintPPrintable
      sharing Single.ContextType = ContextType
      sharing Multi.ContextType = ContextType
      sharing Single.PPrintIndentBase =  PPrintIndentBase
      sharing Multi.PPrintIndentBase =  PPrintIndentBase
      sharing NamingPointeredTypeExtension.PointeredType.BaseType = VariableContexts.Variables
      sharing NamingPointeredTypeExtension.PointeredType = VariableContexts.PointeredType
      sharing Literals.Single =  Single
      sharing Literals.Variables =  Variables
      sharing VariableContexts.VariableContext =  ContextType
      sharing VariableContexts.Variables =  Variables

   end;
