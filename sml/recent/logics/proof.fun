use "general/set.sig";
use "logics/contected.sig";

functor Proof(X:
   sig
      structure C: Contected
      structure S: Set
         where type base_t =  C.Clause.Single.T
   end ) =
   struct

      structure Single =  X.C.Clause.Single
      structure Multi =  X.S

      fun apply_to_literal_telling_progress
             is_conventional
             (proof: Multi.T)
             (literal: X.C.Literal.Single.T)
        = let
             fun omega (cl: Single.T)
               = let
                    val ctxt =  Single.get_context cl
                    val alphaTransform
                      = X.C.Literal.make_alpha_transform(
                              ctxt
                           ,  X.C.Literal.copy )
                    val variableMap =  X.C.Literal.get_alpha_transform alphaTransform
                    val der_cl =  Single.alpha_transform variableMap cl
                    val der_cl_conclusion =  Single.get_conclusion der_cl
                 in if X.C.Literal.Single.equate(
                          der_cl_conclusion
                       ,  literal )
                    then
                       Option.SOME (cl, der_cl)
                    else
                       Option.NONE
                 end
             val psi =  Multi.ofind omega proof
          in case (psi) of
                Option.NONE => X.C.Literal.singleton literal
             |  Option.SOME(cl, der_cl)
                => let
                      val proof'
                        = if is_conventional
                          then
                             proof
                          else
                             Multi.drop(cl, proof)
                      val antecedent =  Single.get_antecedent(der_cl)
                   in multi_apply_to_literal_telling_progress is_conventional proof' antecedent
                   end
          end
      and multi_apply_to_literal_telling_progress
             is_conventional
             proof
             goals
        = X.C.Literal.lift
             (apply_to_literal_telling_progress is_conventional proof)
             goals

      fun apply_to_contected_literal_telling_progress is_conventional proof goal
        = let
             val goal_conclusion =  X.C.ContectedLiteral.Single.get_conclusion goal
             val goal_context =  X.C.ContectedLiteral.Single.get_context goal
             val result_conclusion
               = apply_to_literal_telling_progress is_conventional proof goal_conclusion
             val result
               = X.C.ContectedLiteral.Multi.construct(goal_context, result_conclusion)
          in result
          end

      fun multi_apply_to_contected_literal_telling_progress is_conventional proof goals
        = let
             val goals_conclusion =  X.C.ContectedLiteral.Multi.get_antecedent goals
             val goals_context =  X.C.ContectedLiteral.Multi.get_context goals
             val result_conclusion
               = multi_apply_to_literal_telling_progress is_conventional proof goals_conclusion
             val result
               = X.C.ContectedLiteral.Multi.construct(goals_context, result_conclusion)
          in result
          end

      fun add_clause_to_proof clause proof =  Multi.insert(clause, proof)

      val combine_proofs =  Multi.union

   end
