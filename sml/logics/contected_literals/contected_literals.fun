use "logics/contected_literals.sig";
use "logics/literals.sig";
use "logics/variable_contexts.sig";

functor ContectedLiterals(X:
   sig
      structure Lit: Literals
      structure VarCtxt: VariableContexts
      sharing Lit.Variables = VarCtxt.Variables
   end ) : ContectedLiterals =
   struct
      structure Literals =  X.Lit
      structure VariableContexts =  X.VarCtxt
      structure Variables =  X.Lit.Variables
      type T =  { context: VariableContexts.VariableContext.T, conclusion: Literals.Single.T }
      fun get_t (ctxt, c) =  { context = ctxt, conclusion = c }
      fun get_context (cl: T) =  #context cl
      fun get_conclusion (cl: T) =  #conclusion cl
      fun eq ({ context = ctxt_1, conclusion = c_1}, { context = ctxt_2, conclusion = c_2 })
        = VariableContexts.VariableContext.eq(ctxt_1, ctxt_2) andalso Literals.Single.eq(c_1, c_2)

      fun alpha_convert f { context = ctxt, conclusion = c } =  VariableContexts.alpha_convert f ctxt
      fun apply_alpha_conversion alpha { context = ctxt, conclusion = c }
        = let
             val der_context =  VariableContexts.get_variable_context alpha
             val phi =  VariableContexts.apply_alpha_converter alpha
             val der_conclusion =  Literals.Single.vmap phi c
          in
             { context =  der_context, conclusion = der_conclusion }
          end
   end;

