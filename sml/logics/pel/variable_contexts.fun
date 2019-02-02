use "collections/dicts.fun";
use "collections/dictset.fun";
use "logics/literals.sig";
use "logics/variables.sig";
use "logics/variable_contexts.sig";
use "logics/variables_depending_thing.sig";

functor PELVariableContexts(Var: Variables) =
   struct
      structure DictSet =  DictSet(Var)
      structure Dicts =  Dicts(DictSet)

      structure Variables =  Var

      structure VariableContext: VariablesDependingThing =
         struct
            structure Variables =  Variables
            type T =  (string Option.option ref * Variables.T) list
            fun vmap f s =  List.map (fn (n, v) => (ref (!n), f v)) s
         end;

      type AlphaConverter = { ctxt: VariableContext.T, alpha: Variables.T Dicts.T }

      val get_variable_context: AlphaConverter -> VariableContext.T =  #ctxt

      local
         fun alpha_convert_item f ((name_r, var), a: AlphaConverter)
           = let
                val var_item =   Variables.fcopy f var
                val ctxt_item =  (ref (!name_r), var_item)
                val ctxt =  ctxt_item :: (#ctxt a)
                val alpha =  Dicts.set (var, var_item, #alpha a)
             in
                { ctxt = ctxt, alpha = alpha }
             end
      in
         fun alpha_convert f (vc: VariableContext.T)
           = List.foldl (alpha_convert_item f) { ctxt = nil, alpha = Dicts.empty } vc
      end

      exception OutOfContext
      fun apply_alpha_converter (alpha: AlphaConverter) x
        = case(Dicts.deref(x, #alpha alpha)) of
             Option.NONE => raise OutOfContext
          |  Option.SOME v => v

      fun alpha_zip_all ((alpha: AlphaConverter), (beta: AlphaConverter)) P
        = Dicts.all P (Dicts.zip ((#alpha alpha), (#alpha beta)))

      fun new () =  nil

      local
          fun get_name_ref var var_ctxt
            = Option.map (fn (f, _) => f) (List.find (fn (_, w) => Variables.eq(var, w)) (var_ctxt))
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
