use "collections/dictset.fun";
use "collections/pointered_type.sig";
use "logics/literals.sig";
use "logics/variables.sig";
use "logics/variable_contexts.sig";

functor VariableContexts(X:
   sig
      structure Var: Variables
      structure PT: PointeredType
      sharing PT.BaseType = Var
   end) =
   struct
      structure DictSet =  DictSet(X.Var)
      structure Dicts =  DictSet.Dicts

      structure Variables =  X.Var
      structure PointeredType =  X.PT

      structure VariableContext =
         struct
            structure Variables =  Variables
            type T =  X.PT.ContainerType.T
            val eq =  X.PT.all_zip (X.Var.eq)
            val vmap =  X.PT.map
         end;

      type AlphaConverter = { ctxt: VariableContext.T, alpha: Variables.T Dicts.dict }

      val get_variable_context: AlphaConverter -> VariableContext.T =  #ctxt

      fun alpha_convert (vc: VariableContext.T)
        = let
             val (vc', d)
               = X.PT.mapfold
                   (Variables.copy)
                   (fn (old, new, a: Variables.T Dicts.dict) =>  Dicts.set(old, new, a))
                   Dicts.empty
                   vc
          in
             { ctxt = vc', alpha = d }: AlphaConverter
          end

      exception OutOfContext
      fun apply_alpha_converter (alpha: AlphaConverter) x
        = case(Dicts.deref(x, #alpha alpha)) of
             Option.NONE => raise OutOfContext
          |  Option.SOME v => v

      fun alpha_zip_all ((alpha: AlphaConverter), (beta: AlphaConverter)) P
        = Dicts.all P (Dicts.zip ((#alpha alpha), (#alpha beta)))

      fun alpha_map (alpha: AlphaConverter)
        = let
             val beta =  alpha_convert (#ctxt alpha)
             val result_dict =  Dicts.map (fn v => Option.valOf (Dicts.deref(v, (#alpha beta)))) (#alpha alpha)
          in
             { ctxt =  #ctxt beta, alpha =  result_dict }: AlphaConverter
          end

   end;
