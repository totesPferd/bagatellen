use "collections/occurences.sig";
use "logics/contecteds.sig";
use "logics/literals.sig";
use "logics/variable_contexts.sig";

functor Contecteds(X:
   sig
      structure Lit: Literals
      structure VarCtxt: VariableContexts
      sharing Lit.VariableStructure = VarCtxt.VariableStructure
      sharing Lit.VariableStructure.Map = VarCtxt.Map
   end ): Contecteds  =
   struct
      structure Constructors =  X.Lit.Constructors
      structure Literals =  X.Lit
      structure VariableContexts =  X.VarCtxt
      structure Variables =  X.Lit.Variables

      structure ContectedLiterals =
         struct
            structure Single =
               struct
                  type T =  { context: VariableContexts.VariableContext.T, conclusion: Literals.Single.T }

                  fun eq ({ context = ctxt_1, conclusion = c_1}, { context = ctxt_2, conclusion = c_2 })
                    = VariableContexts.VariableContext.eq(ctxt_1, ctxt_2) andalso Literals.Single.eq(c_1, c_2)

                  fun get_context (ctxt: T) =  #context ctxt
                  fun get_conclusion (cl: T) =  #conclusion cl
                  fun construct(ctxt, c) =  { context = ctxt, conclusion = c }: T

                  fun apply_alpha_conversion (alpha: VariableContexts.AlphaConverter) ({ context = ctxt, conclusion = c }: T)
                    = let
                         val der_context =  VariableContexts.get_variable_context alpha
                         val phi =  VariableContexts.apply_alpha_converter alpha
                         val der_conclusion =  Literals.Single.vmap phi c
                      in
                         { context =  der_context, conclusion = der_conclusion }
                      end
                  fun get_occurences (x:T) =  Literals.Single.get_occurences (#conclusion x)

                  fun equate (c_1: T, c_2: T)
                    = Literals.Single.equate(#conclusion c_1, #conclusion c_2)

               end
            structure Multi =
               struct
                  type T =  { context: VariableContexts.VariableContext.T, antecedent: Literals.Multi.T }

                  fun eq ({ context = ctxt_1, antecedent = a_1 }, { context = ctxt_2, antecedent = a_2 })
                    = VariableContexts.VariableContext.eq(ctxt_1, ctxt_2) andalso Literals.Multi.eq(a_1, a_2)

                  fun get_context (ctxt: T) =  #context ctxt
                  fun get_antecedent (cl: T) =  #antecedent cl
                  fun construct(ctxt, a) =  { context = ctxt, antecedent = a }: T

                  fun apply_alpha_conversion (alpha: VariableContexts.AlphaConverter) ({ context = ctxt, antecedent = a }: T)
                    = let
                         val der_context =  VariableContexts.get_variable_context alpha
                         val phi =  VariableContexts.apply_alpha_converter alpha
                         val der_antecedent =  Literals.Multi.vmap phi a
                      in
                         { context =  der_context, antecedent = der_antecedent }
                      end
                  fun get_occurences (x:T) =  Literals.Multi.get_occurences (#antecedent x)

                  fun empty ctxt =  { context = ctxt, antecedent = Literals.Multi.empty }

                  fun is_empty (a: T) =  Literals.Multi.is_empty(#antecedent a)
               end

            fun transition phi (a: Multi.T)
              = let
                   fun psi (c: Literals.Single.T, b)
                     = phi ({ context = #context a, conclusion = c }: Single.T, b)
                in
                   Literals.transition psi (#antecedent a)
                end

         end

      structure Clauses =
         struct
            structure Single =
               struct
                  type T =  { context: VariableContexts.VariableContext.T, antecedent: Literals.Multi.T, conclusion: Literals.Single.T }

                  fun eq ({ context = ctxt_1, antecedent = a_1, conclusion = c_1 }, { context = ctxt_2, antecedent = a_2, conclusion = c_2 })
                    = VariableContexts.VariableContext.eq(ctxt_1, ctxt_2) andalso Literals.Multi.eq(a_1, a_2) andalso Literals.Single.eq(c_1, c_2)

                  fun get_context (cl: T) =  #context cl
                  fun get_antecedent (cl: T) =  #antecedent cl
                  fun get_conclusion (cl: T) =  #conclusion cl
                  fun construct(ctxt, a, c) =  { context = ctxt, antecedent = a, conclusion = c }: T

                  fun apply_alpha_conversion (alpha: VariableContexts.AlphaConverter) ({ context = ctxt, antecedent = a, conclusion = c }: T)
                    = let
                         val der_context =  VariableContexts.get_variable_context alpha
                         val phi =  VariableContexts.apply_alpha_converter alpha
                         val der_antecedent =  Literals.Multi.vmap phi a
                         val der_conclusion =  Literals.Single.vmap phi c
                      in
                         { context =  der_context, antecedent = der_antecedent, conclusion = der_conclusion }
                      end

                  fun get_occurences (x:T)
                     =  Literals.Occurences.unif_occurences (
                           Literals.Multi.get_occurences (#antecedent x)
                        ,  Literals.Single.get_occurences (#conclusion x) )

                  fun is_assumption(cl: T)
                    = Literals.is_in(#conclusion cl, #antecedent cl)

               end

            structure Multi =
               struct
                  type T =  { context: VariableContexts.VariableContext.T, antecedent: Literals.Multi.T, conclusion: Literals.Multi.T }

                  fun eq ({ context = ctxt_1, antecedent = a_1, conclusion = c_1 }, { context = ctxt_2, antecedent = a_2, conclusion = c_2 })
                    = VariableContexts.VariableContext.eq(ctxt_1, ctxt_2) andalso Literals.Multi.eq(a_1, a_2) andalso Literals.Multi.eq(c_1, c_2)

                  fun get_context (mcl: T) =  #context mcl
                  fun get_antecedent (cl: T) =  #antecedent cl
                  fun get_conclusion (cl: T) =  #conclusion cl
                  fun construct(ctxt, a, c) =  { context = ctxt, antecedent = a, conclusion = c }: T

                  fun apply_alpha_conversion (alpha: VariableContexts.AlphaConverter) ({ context = ctxt, antecedent = a, conclusion = c }: T)
                    = let
                         val der_context =  VariableContexts.get_variable_context alpha
                         val phi =  VariableContexts.apply_alpha_converter alpha
                         val der_antecedent =  Literals.Multi.vmap phi a
                         val der_conclusion =  Literals.Multi.vmap phi c
                      in
                         { context =  der_context, antecedent = der_antecedent, conclusion = der_conclusion }
                      end

                  fun get_occurences (x:T)
                     =  Literals.Occurences.unif_occurences (
                           Literals.Multi.get_occurences (#antecedent x)
                        ,  Literals.Multi.get_occurences (#conclusion x) )

                  fun is_empty (mcl: T) =  Literals.Multi.is_empty(#conclusion mcl)
                  fun is_assumption(mcl: T)
                    = Literals.Multi.subeq(#antecedent mcl, #conclusion mcl)
               end

            fun transition phi (mcl: Multi.T)
              = let
                   val ctxt =  Multi.get_context mcl
                   val antecedent =  Multi.get_antecedent mcl
                   fun psi (c: Literals.Single.T, b)
                     = phi ({ context = ctxt, antecedent = antecedent, conclusion = c }, b)
                in
                   Literals.transition psi (#conclusion mcl)
                end

         end


      fun make_clause_from_conclusion { context = ctxt, conclusion = c }
        = { context = ctxt, antecedent = Literals.Multi.empty, conclusion = c }

      fun make_multi_clause_from_antecedent { context = ctxt, antecedent = a }
        = { context = ctxt, antecedent = Literals.Multi.empty, conclusion = a }

      fun empty_multi_clause { context = ctxt, antecedent = a }
        = { context = ctxt, antecedent = a, conclusion = Literals.Multi.empty }

      fun get_antecedent { context = ctxt, antecedent = a, conclusion = c }
        = { context = ctxt, antecedent = a }

      fun get_conclusion { context = ctxt, antecedent = a, conclusion = c }
        = { context = ctxt, conclusion = c }

      fun multi_get_antecedent { context = ctxt, antecedent = a, conclusion = c }
        = { context = ctxt, antecedent = a }

      fun multi_get_conclusion { context = ctxt, antecedent = a, conclusion = c }
        = { context = ctxt, antecedent = c }

   end;
