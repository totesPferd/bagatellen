use "collections/dicts.fun";
use "collections/dictset.fun";
use "logics/literals.sig";
use "logics/variable_contexts.sig";
use "logics/variables_depending_thing.sig";

functor VariableContexts(Ty: VariablesDependingThing): VariableContexts =
   struct
      structure DictSet =  DictSet(Ty)
      structure Dicts =  Dicts(DictSet)
      structure Variables =  Ty.Variables

      type T =  Ty.L
      type VariableContext =  (string Option.option ref * T Variables.Variable) list
      type AlphaConverter = { ctxt: VariableContext, alpha: T Variables.Variable Dicts.T }

      val get_variable_context: AlphaConverter -> VariableContext =  #ctxt
      fun alpha_convert nil =  { ctxt = nil, alpha = Dicts.empty }
        | alpha_convert ((name_r, var) :: tl)
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
      fun apply_alpha_converter_as_vdt (alpha: AlphaConverter) l =  Ty.pmap (apply_alpha_converter alpha) l

      fun new () =  nil

      local
          fun get_name_ref var var_ctxt
            = Option.map (fn (f, _) => f) (List.find (fn (_, w) => Variables.eq(var, w)) (var_ctxt))
      in
          fun get_name var var_ctxt =  Option.join (Option.map ! (get_name_ref var var_ctxt))
          fun set_name (name, var) var_ctxt =  Option.isSome (Option.map (fn (store) => store := Option.SOME name) (get_name_ref var var_ctxt))
      end
   end;
