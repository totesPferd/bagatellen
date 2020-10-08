use "collections/naming_pointered_type_generating.sig";
use "general/type.sig";
use "logics/literals.sig";
use "logics/pprint/indent_base.sig";
use "logics/pprint/pprintable.sig";
use "logics/variable_contexts.sig";
use "logics/variable_structure.sig";

signature PPrintPPrintableLiterals =
   sig
      structure NamingPointeredTypeGenerating: NamingPointeredTypeGenerating
      structure Literals: Literals
      structure PPrintIndentBase: PPrintIndentBase
      structure VariableContexts: VariableContexts
         where type PointeredTypeExtended.ContainerType.T = NamingPointeredTypeGenerating.PointeredTypeExtended.ContainerType.T
         and   type PointeredTypeExtended.PointerType.T = NamingPointeredTypeGenerating.PointeredTypeExtended.PointerType.T
      structure ContextType: Type
         where type T =  VariableContexts.VariableContext.T
      structure VariableStructure: VariableStructure
      structure Single: PPrintPPrintable
         where type ContextType.T = ContextType.T
      structure Multi: PPrintPPrintable
         where type ContextType.T = ContextType.T
      sharing Single.PPrintIndentBase =  PPrintIndentBase
      sharing Multi.PPrintIndentBase =  PPrintIndentBase
      sharing NamingPointeredTypeGenerating.PointeredTypeExtended.BaseStructure = VariableContexts.VariableStructure
      sharing NamingPointeredTypeGenerating.PointeredTypeExtended.BaseStructureMap = VariableContexts.PointeredTypeExtended.BaseStructureMap
      sharing NamingPointeredTypeGenerating.PointeredTypeExtended.BaseType = VariableContexts.PointeredTypeExtended.BaseType
      sharing Literals.Single = Single
      sharing Literals.VariableStructure = VariableStructure
      sharing VariableContexts.VariableStructure = VariableStructure

   end;
