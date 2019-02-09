use "collections/eqs.sig";
use "collections/pointered_type.sig";
use "logics/variables.sig";
use "logics/variables_depending_thing.sig";

signature VariableContexts =
   sig
      structure PointeredType: PointeredType
      structure Variables: Variables
      structure VariableContext:
         sig
            structure Variables: Variables
            type T
            val eq: T * T -> bool
            val vmap: (Variables.T -> Variables.T) -> T -> T
         end
      sharing VariableContext.Variables =  Variables
      sharing PointeredType.BaseType =  Variables

      type AlphaConverter

      val alpha_convert:                 (Variables.Base -> Variables.Base) -> VariableContext.T -> AlphaConverter
      val get_variable_context:          AlphaConverter -> VariableContext.T
      val apply_alpha_converter:         AlphaConverter -> Variables.T -> Variables.T

      val alpha_zip_all:                 AlphaConverter * AlphaConverter -> (Variables.T * Variables.T -> bool) -> bool
      val alpha_map:                     (Variables.Base -> Variables.Base) -> AlphaConverter -> AlphaConverter
   end;
