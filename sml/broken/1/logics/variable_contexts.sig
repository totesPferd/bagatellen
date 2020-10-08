use "collections/pointered_type_extended.sig";
use "general/eqs.sig";
use "general/map.sig";
use "logics/variable_structure.sig";

signature VariableContexts =
   sig
      structure Map: Map
      structure PointeredTypeExtended: PointeredTypeExtended
      structure VariableStructure: VariableStructure
      structure VariableContext:
         sig
            structure Map: Map
            type T
            val eq:                  T * T -> bool
            val vmap:                Map.Map.T -> T -> T
         end
      sharing Map.Start = VariableStructure
      sharing Map.End = VariableStructure
      sharing PointeredTypeExtended.BaseStructure =  VariableStructure
      sharing PointeredTypeExtended.ContainerType =  VariableContext
      sharing VariableContext.Map =  Map

      type AlphaConverter

      val alpha_convert:                 VariableContext.T -> AlphaConverter
      val get_variable_context:          AlphaConverter -> VariableContext.T
      val apply_alpha_converter:         AlphaConverter -> Map.Map.T

   end;
