use "collections/naming_pointered_type_extension.sig";
use "general/type.sig";
use "logics/literals.sig";
use "logics/pprint/indent_base.sig";
use "logics/pprint/pprintable.sig";
use "logics/variable_contexts.sig";
use "logics/variable_structure.sig";

signature PPrintPPrintableLiterals =
   sig
      structure ContextType: Type
      structure Literals: Literals
      structure NamingPointeredTypeExtension: NamingPointeredTypeExtension
      structure PPrintIndentBase: PPrintIndentBase
      structure VariableContexts: VariableContexts
      structure VariableStructure: VariableStructure
      structure Single: PPrintPPrintable
      structure Multi: PPrintPPrintable
      sharing Single.ContextType = ContextType
      sharing Multi.ContextType = ContextType
      sharing Single.PPrintIndentBase =  PPrintIndentBase
      sharing Multi.PPrintIndentBase =  PPrintIndentBase
      sharing NamingPointeredTypeExtension.PointeredTypeExtended.BaseStructure = VariableContexts.VariableStructure
      sharing NamingPointeredTypeExtension.PointeredTypeExtended = VariableContexts.PointeredTypeExtended
      sharing Literals.Single = Single
      sharing Literals.VariableStructure = VariableStructure
      sharing VariableContexts.VariableContext = ContextType
      sharing VariableContexts.VariableStructure = VariableStructure

   end;
