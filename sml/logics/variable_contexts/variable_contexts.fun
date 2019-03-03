use "collections/dict_map.sig";
use "collections/dictset.sig";
use "collections/pointered_type_extended.sig";
use "logics/literals.sig";
use "logics/variable_contexts.sig";
use "logics/variables.sig";
use "pointered_types/pointered_functor.sig";

functor VariableContexts(X:
   sig
      structure Var: Variables
      structure PF: PointeredFunctor
      structure PT: PointeredTypeExtended
      structure DM: DictMap
      structure DS: DictSet
      sharing PT.BaseType = Var
      sharing DM.DictSet = DS
      sharing DM.Start = Var
      sharing DM.End = Var
      sharing DS.Eqs = Var
      sharing PF.Start = PT
      sharing PF.End = PT
      sharing PF.Map.Map = DM.Map
   end) =
   struct
      structure Dicts =  X.DS.Dicts
      structure DictMap = X.DM

      structure Map = X.PF.Map

      structure Variables =  X.Var
      structure PointeredTypeExtended =  X.PT

      structure VariableContext =
         struct
            type T =  X.PT.ContainerType.T
            val eq =  X.PT.all_zip (X.Var.eq)
            val vmap =  X.PF.map
            val filter_bound_vars =  X.PT.filter (Variables.is_bound)
            val filter_unbound_vars =  X.PT.filter (not o Variables.is_bound)
         end;

      type AlphaConverter = { ctxt: VariableContext.T, alpha: Variables.T Dicts.dict }

      val get_variable_context: AlphaConverter -> VariableContext.T =  #ctxt

      fun alpha_convert (vc: VariableContext.T)
        = let
             val var_dict
                =  X.PT.transition
                      (fn (v, d) => Option.SOME (Dicts.set(v, (Variables.copy v), d)))
                      vc
                      Dicts.empty
             val dict_map =  DictMap.get_map var_dict
             val ctxt_map =  X.PF.map dict_map
             val vc' =  ctxt_map vc
          in
             { ctxt = vc', alpha = var_dict }: AlphaConverter
          end

      exception OutOfContext
      fun apply_alpha_converter (alpha: AlphaConverter) x
        = case(Dicts.deref(x, #alpha alpha)) of
             Option.NONE => raise OutOfContext
          |  Option.SOME v => v

   end;
