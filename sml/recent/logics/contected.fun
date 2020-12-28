use "logics/literal.sig";

functor Contected(X:
   sig
      structure Lit: Literal
   end ) =
   struct

      structure ContectedLiteral =
         struct
            structure Single =
               struct
                  type T =  { context: X.Lit.VariableContext.T, conclusion: X.Lit.Single.T }
      
                  fun eq ({ context = ctxt_1, conclusion = c_1 }, { context = ctxt_2, conclusion = c_2 }) =
                        X.Lit.VariableContext.eq (ctxt_1, ctxt_2)
                  andalso
                        X.Lit.Single.eq (c_1, c_2)
      
                  fun get_context (cl: T) =  #context cl
                  fun get_conclusion (cl: T) =  #conclusion cl
                  fun construct(ctxt, c) =  { context = ctxt, conclusion = c }: T
      
                  fun alpha_transform phi { context = ctxt, conclusion = c } =
                     {
                        context = (X.Lit.context_alpha_transform phi ctxt)
                     ,  conclusion = (X.Lit.single_alpha_transform phi c) }
      
                  fun equate (c_1: T, c_2: T)
                     = X.Lit.Single.equate(#conclusion c_1, #conclusion c_2)
      
               end

            structure Multi =
               struct
                  type T =  { context: X.Lit.VariableContext.T, antecedent: X.Lit.Multi.T }
      
                  fun eq ({ context = ctxt_1, antecedent = a_1 }, { context = ctxt_2, antecedent = a_2 }) =
                        X.Lit.VariableContext.eq (ctxt_1, ctxt_2)
                  andalso
                        X.Lit.Multi.eq (a_1, a_2)
      
                  fun get_context (cl: T) =  #context cl
                  fun get_antecedent (cl: T) =  #antecedent cl
                  fun construct(ctxt, a) =  { context = ctxt, antecedent = a }: T
      
                  fun alpha_transform phi { context = ctxt, antecedent = a } =
                     {
                        context = (X.Lit.context_alpha_transform phi ctxt)
                     ,  conclusion = (X.Lit.multi_alpha_transform phi a) }
      
                  fun equate (a_1: T, a_2: T)
                     = X.Lit.Multi.equate(#antecedent a_1, #antecedent a_2)

                  fun empty ctxt =  { context = ctxt, antecedent = X.Lit.Multi.empty }
                  fun is_empty (a: T) =  X.Lit.Multi.is_empty (#antecedent a)
      
               end

      end

      structure Clause =
         struct
            structure Single =
               struct
                  type T =  {
                        context: X.Lit.VariableContext.T
                     ,  antecedent: X.Lit.Multi.T
                     ,  conclusion: X.Lit.Single.T }
      
                  fun eq ({
                           context = ctxt_1
                        ,  antecedent = a_1
                        ,  conclusion = c_1 }
                     ,  {
                           context = ctxt_2
                        ,  antecedent = a_2
                        ,  conclusion = c_2 }) =
                        X.Lit.VariableContext.eq (ctxt_1, ctxt_2)
                  andalso
                        X.Lit.Multi.eq (a_1, a_2)
                  andalso
                        X.Lit.Single.eq (c_1, c_2)
      
                  fun get_context (cl: T) =  #context cl
                  fun get_antecedent (cl: T) =  #antecedent cl
                  fun get_conclusion (cl: T) =  #conclusion cl
                  fun construct(ctxt, a, c) =  { context = ctxt, antecedent = a, conclusion = c }: T
      
                  fun alpha_transform phi { context = ctxt, antecedent = a, conclusion = c } =
                     {
                        context = (X.Lit.context_alpha_transform phi ctxt)
                     ,  antecedent = (X.Lit.multi_alpha_transform phi a)
                     ,  conclusion = (X.Lit.single_alpha_transform phi c) }

                  fun is_assumption { context = ctxt, antecedent = a, conclusion = c } =
                     X.Lit.is_in (a, c)
      
               end

            structure Multi =
               struct
                  type T =  {
                        context: X.Lit.VariableContext.T
                     ,  antecedent: X.Lit.Multi.T
                     ,  conclusion: X.Lit.Multi.T }
      
                  fun eq ({
                              context = ctxt_1
                           ,  antecedent = a_1
                           ,  conclusion = c_1 }
                     ,  {
                              context = ctxt_2
                           ,  antecedent = a_2
                           ,  conclusion = c_2 }) =
                        X.Lit.VariableContext.eq (ctxt_1, ctxt_2)
                  andalso
                        X.Lit.Multi.eq (a_1, a_2)
                  andalso
                        X.Lit.Multi.eq (c_1, c_2)
      
                  fun get_context (cl: T) =  #context cl
                  fun get_antecedent (cl: T) =  #antecedent cl
                  fun get_conclusion (cl: T) =  #conclusion cl
                  fun construct(ctxt, a,c ) =  { context = ctxt, antecedent = a, conclusion = c }: T
      
                  fun alpha_transform phi { context = ctxt, antecedent = a, conclusion = c } =
                     {
                        context = (X.Lit.context_alpha_transform phi ctxt)
                     ,  antecedent = (X.Lit.multi_alpha_transform phi a)
                     ,  conclusion = (X.Lit.multi_alpha_transform phi c) }
      
                  fun is_empty (a: T) =  X.Lit.Multi.is_empty (#conclusion a)

                  fun is_assumption { context = ctxt, antecedent = a, conclusion = c } =
                     X.Lit.subeq(a, c)
      
               end

      end

      fun make_clause_from_conclusion { context = ctxt, conclusion = c }
        = { context = ctxt, antecedent = X.Lit.Multi.empty, conclusion = c }

      fun make_multi_clause_from_antecedent { context = ctxt, antecedent = a }
        = { context = ctxt, antecedent = X.Lit.Multi.empty, conclusion = a }

      fun empty_multi_clause { context = ctxt, antecedent = a }
        = { context = ctxt, antecedent = a, conclusion = X.Lit.Multi.empty }

      fun get_antecedent { context = ctxt, antecedent = a, conclusion = c }
        = { context = ctxt, antecedent = a }

      fun get_conclusion { context = ctxt, antecedent = a, conclusion = c }
        = { context = ctxt, conclusion = c }

      fun multi_get_antecedent { context = ctxt, antecedent = a, conclusion = c }
        = { context = ctxt, antecedent = a }

      fun multi_get_conclusion { context = ctxt, antecedent = a, conclusion = c }
        = { context = ctxt, antecedent = c }

   end
