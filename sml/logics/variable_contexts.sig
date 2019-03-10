use "general/eqs.sig";
use "general/map.sig";
use "collections/pointered_type_extended.sig";
use "logics/variables.sig";

signature VariableContexts =
   sig
      structure Map: Map
      structure PointeredTypeExtended: PointeredTypeExtended
      structure Variables: Variables
      structure VariableContext:
         sig
            structure Map: Map
            type T
            val eq:                  T * T -> bool
            val vmap:                Map.Map.T -> T -> T
         end
      sharing Map.Start = Variables
      sharing Map.End = Variables
      sharing PointeredTypeExtended.BaseType =  Variables
      sharing PointeredTypeExtended.ContainerType =  VariableContext
      sharing VariableContext.Map =  Map

      type AlphaConverter

      val alpha_convert:                 VariableContext.T -> AlphaConverter
      val get_variable_context:          AlphaConverter -> VariableContext.T
      val apply_alpha_converter:         AlphaConverter -> Map.Map.T

   end;
