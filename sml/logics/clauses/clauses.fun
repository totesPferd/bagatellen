use "logics/clauses.sig";
use "logics/literals.sig";
use "logics/variable_contexts.sig";

functor Clauses(X:
   sig
      structure Lit: Literals
      structure VarCtxt: VariableContexts
      sharing Lit.Variables = VarCtxt.Variables
   end ): Clauses =
   struct
      structure Literals =  X.Lit
      structure VariableContexts =  X.VarCtxt
      structure Variables =  X.Lit.Variables
      type T =  { context: VariableContexts.VariableContext.T, antecedent: Literals.Multi.T, conclusion: Literals.Single.T }
      fun get_t (ctxt, a, c) =  { context = ctxt, antecedent = a, conclusion = c }
      fun get_context (cl: T) =  #context cl
      fun get_antecedent (cl: T) =  #antecedent cl
      fun get_conclusion (cl: T) =  #conclusion cl
      fun eq ({ context = ctxt_1, antecedent = a_1, conclusion = c_1}, { context = ctxt_2, antecedent = a_2, conclusion = c_2 })
        = VariableContexts.VariableContext.eq(ctxt_1, ctxt_2) andalso Literals.Multi.eq(a_1, a_2) andalso Literals.Single.eq(c_1, c_2)

      fun alpha_convert f { context = ctxt, antecedent = a, conclusion = c } =  VariableContexts.alpha_convert f ctxt
      fun apply_alpha_conversion alpha { context = ctxt, antecedent = a, conclusion = c }
        = let
             val der_context =  VariableContexts.get_variable_context alpha
             val der_antecedent =  Literals.Multi.vmap (VariableContexts.apply_alpha_converter alpha) a
             val der_conclusion =  Literals.Single.vmap (VariableContexts.apply_alpha_converter alpha) c
          in
             { context =  der_context, antecedent = der_antecedent, conclusion = der_conclusion }
          end

      fun resolve { context = ctxt, antecedent = antecedent, conclusion = conclusion } pointer base
        = let
             val item =  Literals.select(pointer, base)
          in
             if Literals.Single.equate(conclusion, item)
             then
                Option.SOME (Literals.replace(item, antecedent) base)
             else
                Option.NONE
          end

   end;
