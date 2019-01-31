use "collections/dicts.fun";
use "collections/dictset.fun";
use "logics/literals.sig";
use "logics/variable_contexts.sig";
use "logics/variables_depending_thing.sig";

functor VariableContexts(Ty: VariablesDependingThing): VariableContexts =
   struct
      structure TyEq =
         struct
            type T = Ty.Variables.Variable
            val eq = Ty.Variables.veq
         end
      structure DictSet =  DictSet(TyEq)
      structure Dicts =  Dicts(DictSet)

      structure Variables =  Ty.Variables

      type T =  Ty.L
      type VariableContext =  (string Option.option ref * Ty.Variables.Variable) list
      type AlphaConverter = { ctxt: VariableContext, alpha: Ty.Variables.Variable Dicts.T }

      val get_variable_context: AlphaConverter -> VariableContext =  #ctxt
      fun alpha_convert nil =  { ctxt = nil, alpha = Dicts.empty }
        | alpha_convert ((name_r, var) :: tl)
        = let
             val step_tl =  alpha_convert tl
             val var_hd =   Ty.Variables.vcopy(var)
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
            = Option.map (fn (f, _) => f) (List.find (fn (_, w) => Ty.Variables.veq(var, w)) (var_ctxt))
      in
          fun get_name var var_ctxt =  Option.join (Option.map ! (get_name_ref var var_ctxt))
          fun set_name (name, var) var_ctxt =  Option.isSome (Option.map (fn (store) => store := Option.SOME name) (get_name_ref var var_ctxt))
      end

      fun uniquize(var_ctxt)
        = let
             fun rename(do_not_use_list, candidate)
               = if (List.exists (fn (n) => (n = candidate)) do_not_use_list)
                 then
                    rename(do_not_use_list, candidate ^ "'")
                 else
                    candidate
             fun get_candidate(name_r, var)
               = (
                    case (!name_r) of
                       Option.NONE => "x"
                    |  Option.SOME n => n )
             fun get_next_do_not_use_list((name_r, var), do_not_use_list)
               = let
                    val new_name =  rename(do_not_use_list, get_candidate(name_r, var))
                 in
                    (
                       name_r := Option.SOME new_name;
                       (new_name :: do_not_use_list) )
                 end;
          in
             (List.foldl (get_next_do_not_use_list) nil var_ctxt; ())
          end
   end;
