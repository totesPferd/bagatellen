use "logics/contecteds.sig";
use "logics/literals.sig";
use "logics/variable_contexts.sig";

functor Contecteds(X:
   sig
      structure Lit: Literals
      structure VarCtxt: VariableContexts
      sharing Lit.Variables = VarCtxt.Variables
   end ): Contecteds  =
   struct
      structure Literals =  X.Lit
      structure VariableContexts =  X.VarCtxt
      structure Variables =  X.Lit.Variables

      structure Clauses =
         struct
            structure Literals =  Literals
            structure VariableContexts =  VariableContexts
            type T =  { context: VariableContexts.VariableContext.T, antecedent: Literals.Multi.T, conclusion: Literals.Single.T }

            fun eq ({ context = ctxt_1, antecedent = a_1, conclusion = c_1 }, { context = ctxt_2, antecedent = a_2, conclusion = c_2 })
              = VariableContexts.VariableContext.eq(ctxt_1, ctxt_2) andalso Literals.Multi.eq(a_1, a_2) andalso Literals.Single.eq(c_1, c_2)

            fun get_context (cl: T) =  #context cl
            fun get_antecedent (cl: T) =  #antecedent cl
            fun get_conclusion (cl: T) =  #conclusion cl
            fun construct(ctxt, a, c) =  { context = ctxt, antecedent = a, conclusion = c }: T

            fun apply_alpha_conversion alpha { context = ctxt, antecedent = a, conclusion = c }
              = let
                   val der_context =  VariableContexts.get_variable_context alpha
                   val phi =  VariableContexts.apply_alpha_converter alpha
                   val der_antecedent =  Literals.Multi.vmap phi a
                   val der_conclusion =  Literals.Single.vmap phi c
                in
                   { context =  der_context, antecedent = der_antecedent, conclusion = der_conclusion }
                end

            fun is_assumption(cl: T)
              = Literals.is_in(#conclusion cl, #antecedent cl)

         end

      structure Antecedents =
         struct
            structure Literals =  Literals
            structure VariableContexts =  VariableContexts
            type T =  { context: VariableContexts.VariableContext.T, antecedent: Literals.Multi.T }

            fun eq ({ context = ctxt_1, antecedent = a_1 }, { context = ctxt_2, antecedent = a_2 })
              = VariableContexts.VariableContext.eq(ctxt_1, ctxt_2) andalso Literals.Multi.eq(a_1, a_2)

            fun get_context (ctxt: T) =  #context ctxt
            fun get_antecedent (cl: T) =  #antecedent cl
            fun construct(ctxt, a) =  { context = ctxt, antecedent = a }: T

            fun apply_alpha_conversion alpha { context = ctxt, antecedent = a }
              = let
                   val der_context =  VariableContexts.get_variable_context alpha
                   val phi =  VariableContexts.apply_alpha_converter alpha
                   val der_antecedent =  Literals.Multi.vmap phi a
                in
                   { context =  der_context, antecedent = der_antecedent }
                end

            fun empty ctxt =  { context = ctxt, antecedent = Literals.Multi.empty() }

            fun is_empty (a: T) =  Literals.Multi.is_empty(#antecedent a)
         end

      structure Conclusions =
         struct
            structure Literals =  Literals
            structure VariableContexts =  VariableContexts
            type T =  { context: VariableContexts.VariableContext.T, conclusion: Literals.Single.T }

            fun eq ({ context = ctxt_1, conclusion = c_1}, { context = ctxt_2, conclusion = c_2 })
              = VariableContexts.VariableContext.eq(ctxt_1, ctxt_2) andalso Literals.Single.eq(c_1, c_2)

            fun get_context (ctxt: T) =  #context ctxt
            fun get_conclusion (cl: T) =  #conclusion cl
            fun construct(ctxt, c) =  { context = ctxt, conclusion = c }: T

            fun apply_alpha_conversion alpha { context = ctxt, conclusion = c }
              = let
                   val der_context =  VariableContexts.get_variable_context alpha
                   val phi =  VariableContexts.apply_alpha_converter alpha
                   val der_conclusion =  Literals.Single.vmap phi c
                in
                   { context =  der_context, conclusion = der_conclusion }
                end

            fun equate (c_1: T, c_2: T)
              = Literals.Single.equate(#conclusion c_1, #conclusion c_2)

         end

      structure MultiClauses =
         struct
            structure Literals =  Literals
            structure VariableContexts =  VariableContexts
            type T =  { context: VariableContexts.VariableContext.T, antecedent: Literals.Multi.T, conclusion: Literals.Multi.T }

            fun eq ({ context = ctxt_1, antecedent = a_1, conclusion = c_1 }, { context = ctxt_2, antecedent = a_2, conclusion = c_2 })
              = VariableContexts.VariableContext.eq(ctxt_1, ctxt_2) andalso Literals.Multi.eq(a_1, a_2) andalso Literals.Multi.eq(c_1, c_2)

            fun get_context (mcl: T) =  #context mcl
            fun get_antecedent (cl: T) =  #antecedent cl
            fun get_conclusion (cl: T) =  #conclusion cl
            fun construct(ctxt, a, c) =  { context = ctxt, antecedent = a, conclusion = c }: T

            fun apply_alpha_conversion alpha { context = ctxt, antecedent = a, conclusion = c }
              = let
                   val der_context =  VariableContexts.get_variable_context alpha
                   val phi =  VariableContexts.apply_alpha_converter alpha
                   val der_antecedent =  Literals.Multi.vmap phi a
                   val der_conclusion =  Literals.Multi.vmap phi c
                in
                   { context =  der_context, antecedent = der_antecedent, conclusion = der_conclusion }
                end

            fun is_empty (mcl: T) =  Literals.Multi.is_empty(#conclusion mcl)
            fun is_assumption(mcl: T)
              = Literals.Multi.subeq(#antecedent mcl, #conclusion mcl)
         end


      fun make_clause_from_conclusion { context = ctxt, conclusion = c }
        = { context = ctxt, antecedent = Literals.Multi.empty(), conclusion = c }

      fun get_antecedent { context = ctxt, antecedent = a, conclusion = c }
        = { context = ctxt, antecedent = a }

      fun get_conclusion { context = ctxt, antecedent = a, conclusion = c }
        = { context = ctxt, conclusion = c }

      fun multi_get_antecedent { context = ctxt, antecedent = a, conclusion = c }
        = { context = ctxt, antecedent = a }

      fun multi_get_conclusion { context = ctxt, antecedent = a, conclusion = c }
        = { context = ctxt, antecedent = c }

      fun fe { context = ctxt, conclusion = c }
        = { context = ctxt, antecedent = Literals.fe c }

      fun multi_fe { context = ctxt, antecedent = a, conclusion = c}
        = { context = ctxt, antecedent = a, conclusion = Literals.fe c }

      fun transition phi (a: Antecedents.T)
        = let
             fun psi (c: Literals.Single.T, b)
               = phi ({ context = #context a, conclusion = c }: Conclusions.T, b)
          in
             Literals.transition psi (#antecedent a)
          end
   end;
