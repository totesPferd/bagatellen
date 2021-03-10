use "general/set.sig";
use "logics/contected.sig";
use "logics/proof.sig";

functor Proof(X:
   sig
      structure C: Contected
      structure S: Set
         where type base_t =  C.Clause.Single.T
   end ): Proof =
   struct

      type clause_t =  X.C.Clause.Single.T
      type multi_clause_t =  X.C.Clause.Multi.T
      type proof_t =  X.S.T

      fun apply_to_literal_telling_progress
             is_conventional
             proof
             clause
        = if X.C.Clause.Single.is_assumption clause
          then
             { result = X.C.Literal.Multi.empty, progress = true }
          else
             let
                val ctxt =  X.C.Clause.Single.get_context
                       clause
                val antecedent =  X.C.Clause.Single.get_antecedent
                       clause
                val literal =  X.C.Clause.Single.get_conclusion
                       clause
                fun omega cl
                  = let
                       val ctxt =  X.C.Clause.Single.get_context cl
                       val alphaTransform
                         = X.C.Literal.make_alpha_transform(
                                 ctxt
                              ,  X.C.Literal.copy )
                       val variableMap =  X.C.Literal.get_alpha_transform alphaTransform
                       val der_cl =  X.C.Clause.Single.alpha_transform variableMap cl
                       val der_cl_conclusion =  X.C.Clause.Single.get_conclusion der_cl
                    in if X.C.Literal.Single.equate(
                             der_cl_conclusion
                          ,  literal )
                       then
                          Option.SOME (cl, der_cl)
                       else
                          Option.NONE
                    end
                val psi =  X.S.ofind omega proof
             in case (psi) of
                   Option.NONE
                   => { result = X.C.Literal.singleton literal,
                        progress = false }
                |  Option.SOME(cl, der_cl)
                   => let
                         val proof'
                           = if is_conventional
                             then
                                proof
                             else
                                X.S.drop(cl, proof)
                         val clauses =  X.C.Clause.Multi.construct(
                                   ctxt
                                ,  antecedent
                                ,  X.C.Clause.Single.get_antecedent(
                                         der_cl ))
                      in { result = multi_apply_to_literals
                              is_conventional
                              proof'
                              clauses,
                           progress = true }
                      end
             end
      and apply_to_literal
             is_conventional
             proof
             (clause: X.C.Clause.Single.T)
        = #result (apply_to_literal_telling_progress
             is_conventional
             proof
             clause )
      and multi_apply_to_literals
             is_conventional
             proof
             clauses
        = let
             val ctxt =  X.C.Clause.Multi.get_context(clauses)
             val premises =  X.C.Clause.Multi.get_antecedent(clauses)
             val conclusions =  X.C.Clause.Multi.get_conclusion(clauses)
             fun f (l: X.C.Literal.Single.T)
               = let
                    val clause =  X.C.Clause.Single.construct(
                          ctxt
                       ,  premises
                       ,  l )
                 in apply_to_literal is_conventional proof clause
                 end
          in X.C.Literal.lift f conclusions
          end

      fun apply_to_clause_telling_progress is_conventional proof clause
        = let
             val ctxt =  X.C.Clause.Single.get_context clause
             val antecedent =  X.C.Clause.Single.get_antecedent clause
             val conclusion =  apply_to_literal_telling_progress
                    is_conventional
                    proof
                    clause
          in { result =  X.C.Clause.Multi.construct(
                     ctxt
                  ,  antecedent
                  ,  #result conclusion )
             , progress =  #progress conclusion }
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

      fun add_clause_to_proof clause proof
        = X.S.insert(clause, proof)
      fun add_multi_clause_to_proof mcl proof
        = let
             val ctxt = X.C.Clause.Multi.get_context(mcl)
             val antecedent =  X.C.Clause.Multi.get_antecedent(mcl)
             val multi_literal =  X.C.Clause.Multi.get_conclusion(mcl)
             fun f (l, bf)
               = let
                    val proof' =  bf()
                    val clause =  X.C.Clause.Single.construct(
                              ctxt
                           ,  antecedent
                           ,  l )
                 in add_clause_to_proof clause proof'
                 end
          in X.C.Literal.transition f multi_literal proof
          end

      val combine_proofs =  X.S.union

      fun mini_complete proof
        = case (X.S.getItem proof) of
             Option.NONE =>  proof
          |  Option.SOME (cl, p_1)
             => let
                   val p_2 =  mini_complete p_1
                   val r =  apply_to_clause_telling_progress
                          false
                          p_2
                          cl
                in
                   if (#progress r)
                   then
                      if (X.C.Clause.Multi.is_empty (#result r))
                      then
                         p_2
                      else
                         let
                            val p_3 =  add_multi_clause_to_proof
                                   (#result r)
                                   p_2
                         in
                            mini_complete p_3
                         end
                   else
                      X.S.adjunct(cl, p_2)
                end
      fun reduce_double_occurences proof
        = case (X.S.getItem proof) of
             Option.NONE =>  proof
          |  Option.SOME (cl, p_1)
             => let
                   val p_2 =  reduce_double_occurences p_1
                   val r =  apply_to_clause_telling_progress
                          false
                          p_2
                          cl
                in
                   if (
                         (#progress r)
                 andalso X.C.Clause.Multi.is_empty (#result r) )
                   then
                      p_2
                   else
                      X.S.adjunct(cl, p_2)
                end

      val fe =  X.S.fe
      val fop =  X.S.fop
      val is_in =  X.S.is_in

      val transition =  X.S.transition

   end
