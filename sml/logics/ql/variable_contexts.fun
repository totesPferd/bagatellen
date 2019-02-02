use "logics/literals.sig";
use "logics/variables.sig";
use "logics/variables_depending_thing.sig";

functor QLVariableContexts(Var: Variables) =
   struct
      structure Variables =  Var

      structure VariableContext: VariablesDependingThing =
         struct
            structure Variables =  Variables
            type T =  Variables.T
            fun vmap f =  f
         end;

      type AlphaConverter = { ctxt: VariableContext.T, dst: Variables.T, src: Variables.T }

      val get_variable_context: AlphaConverter -> VariableContext.T =  #ctxt
      fun alpha_convert f v
        = let
             val vcopy =  Variables.fcopy f v
          in
             { ctxt = vcopy, dst = vcopy, src = v }
          end

      exception OutOfContext
      fun apply_alpha_converter (alpha: AlphaConverter) x
        = if Variables.eq(x, (#src alpha))
          then
             #dst alpha
          else
             raise OutOfContext

      fun alpha_zip_all ((alpha: AlphaConverter), (beta: AlphaConverter)) (P: Variables.T * Variables.T -> bool)
       =  P ((#dst alpha), (#dst beta))
   end;
