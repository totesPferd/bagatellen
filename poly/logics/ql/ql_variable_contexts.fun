use "collections/type.sig";
use "logics/literals.sig";
use "logics/variable_contexts.sig";
use "logics/variables_depending_thing.sig";

functor QLVariableContexts(Ty: VariablesDependingThing): VariableContexts =
   struct
      structure Variables =  Ty.Variables

      type T =  Ty.L
      type VariableContext =  T Variables.Variable Option.option
      type AlphaConverter = { ctxt: VariableContext, alpha: T Variables.Variable Option.option }

      val get_variable_context: AlphaConverter -> VariableContext =  #ctxt
      fun alpha_convert Option.NONE =  { ctxt = Option.NONE, alpha = Option.NONE }
        | alpha_convert (Option.SOME var)
        = let
             val new_var =   Variables.copy(var)
          in
             { ctxt = Option.SOME var, alpha = Option.SOME new_var }
          end

      fun apply_alpha_converter (alpha: AlphaConverter) x
        = let
             val ctxt =  #ctxt alpha
          in case (ctxt) of
                Option.NONE => Option.NONE
             |  Option.SOME y
             => if Ty.eq(x, y)
                then
                   #alpha alpha
                else
                   Option.NONE
          end
      fun apply_alpha_converter_as_vdt (alpha: AlphaConverter) l =  Ty.pmap (apply_alpha_converter alpha) l

   end;
