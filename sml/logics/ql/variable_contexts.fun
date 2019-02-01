use "logics/literals.sig";
use "logics/variables.sig";

functor QLVariableContexts(Var: Variables) =
   struct
      structure Variables =  Var

      type VariableContext =  Variables.T
      type AlphaConverter = { ctxt: VariableContext, dst: Variables.T, src: Variables.T }

      val get_variable_context: AlphaConverter -> VariableContext =  #ctxt
      fun alpha_convert v
        = let
             val vcopy =  Variables.copy v
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

   end;
