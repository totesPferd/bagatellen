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

      fun apply_to_literal
             is_conventional
             (proof: Multi.T)
             (clause: Single.T)
        = if Single.is_assumption clause
          then
             X.C.Literal.Multi.empty
          else
             let
                val ctxt =  Single.get_context clause
                val antecedent =  Single.get_antecedent clause
                val literal =  Single.get_conclusion clause
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
                         val clauses =  X.C.Clause.Multi.construct(
                                   ctxt
                                ,  antecedent
                                ,  Single.get_antecedent(der_cl) )
                      in multi_apply_to_literals is_conventional proof' clauses
                      end
             end
      and multi_apply_to_literals
             is_conventional
             proof
             (clauses: X.C.Clause.Multi.T)
        = let
             val ctxt =  X.C.Clause.Multi.get_context(clauses)
             val premises =  X.C.Clause.Multi.get_antecedent(clauses)
             val conclusions =  X.C.Clause.Multi.get_conclusion(clauses)
             fun f (l: X.C.Literal.Single.T)
               = let
                    val clause =  Single.construct(ctxt, premises, l)
                 in apply_to_literal is_conventional proof clause
                 end
          in X.C.Literal.lift f conclusions
          end

      fun apply_to_clause is_conventional proof clause
        = let
             val ctxt =  X.C.Clause.Single.get_context clause
             val antecedent =  X.C.Clause.Single.get_antecedent clause
             val conclusion =  apply_to_literal is_conventional proof clause
          in X.C.Clause.Multi.construct(ctxt, antecedent, conclusion)
          end

      fun multi_apply_to_clauses is_conventional proof clauses
        = let
             val ctxt =  X.C.Clause.Multi.get_context clauses
             val antecedent =  X.C.Clause.Multi.get_antecedent clauses
             val conclusion =  multi_apply_to_literals is_conventional proof clauses
          in X.C.Clause.Multi.construct(ctxt, antecedent, conclusion)
          end

      val apply =  apply_to_clause false
      val apply_conventional =  apply_to_clause true
      val multi_apply =  multi_apply_to_clauses false
      val multi_apply_conventional =  multi_apply_to_clauses true

      fun add_clause_to_proof clause proof =  Multi.insert(clause, proof)

      val combine_proofs =  Multi.union

      val fe =  Multi.fe
      val fop =  Multi.fop
      val is_in =  Multi.is_in

      val transition =  Multi.transition

   end
