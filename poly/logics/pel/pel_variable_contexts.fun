use "collections/dicts.fun";
use "collections/type.sig";
use "logics/literals.sig";
use "logics/variable_contexts.sig";
use "logics/variables_depending_thing.sig";
use "logics/variables/var_eq.fun";

functor PELVariableContexts(Ty: VariablesDependingThing): VariableContexts =
   struct
      structure VarEq =  VarEq(Ty)
      structure Dicts =  Dicts(VarEq)
      structure Variables =  VarEq.Variables

      type T =  Ty.T
      type VariableContext =  (string Option.option ref * Ty.T Variables.Variable) list
      type AlphaConverter = { ctxt: VariableContext, alpha: Ty.T Variables.Variable Dicts.T }

      val get_variable_context: AlphaConverter -> VariableContext =  #ctxt
      fun alpha_convert nil =  { ctxt = nil, alpha = Dicts.empty }
        | alpha_convert ((name_r, (var: Ty.T Variables.Variable)) :: tl)
        = let
             val step_tl =  alpha_convert tl
             val var_hd =   Variables.copy(var)
             val ctxt_hd =  (ref (!name_r), var_hd)
             val ctxt =     ctxt_hd :: (#ctxt step_tl)
             val alpha =    Dicts.set (var, var_hd, #alpha step_tl)
          in
             { ctxt = ctxt, alpha = alpha }
          end

      fun apply_alpha_converter (alpha: AlphaConverter) x =  Dicts.deref(x, #alpha alpha)

      fun new () =  nil

      local
          fun get_name_ref var var_ctxt
            = Option.map (fn (f, _) => f) (List.find (fn (_, w) => Variables.eq(var, w)) (var_ctxt))
      in
          fun get_name var var_ctxt =  Option.join (Option.map ! (get_name_ref var var_ctxt))
          fun set_name (name, var) var_ctxt =  Option.isSome (Option.map (fn (store) => store := Option.SOME name) (get_name_ref var var_ctxt))
      end
   end;
