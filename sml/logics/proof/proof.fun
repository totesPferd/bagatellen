use "collections/dictset.fun";
use "collections/sets.fun";
use "logics/contecteds.sig";
use "logics/literals.sig";
use "logics/proof.sig";
use "logics/variable_contexts.sig";

functor Proof(X: Contecteds): Proof =
   struct
      structure Contecteds =  X

      structure ClauseDictSet =  DictSet(Contecteds.Clauses)
      structure ClauseSet =  Sets(ClauseDictSet)

      type Proof =  ClauseSet.T

      fun apply_telling_progress is_conventional (proof: Proof) (goal: Contecteds.Clauses.T)
        = if Contecteds.Clauses.is_assumption goal
          then
             Option.SOME (Contecteds.empty_multi_clause (Contecteds.get_antecedent goal))
          else
             let
                fun omega (cl: Contecteds.Clauses.T)
                  = let
                       val ctxt =  Contecteds.Clauses.get_context cl
                       val alpha =  Contecteds.VariableContexts.alpha_convert (fn x => x) ctxt
                       val der_cl =  Contecteds.Clauses.apply_alpha_conversion alpha cl
                    in
                       if Contecteds.Literals.Single.equate(Contecteds.Clauses.get_conclusion der_cl, Contecteds.Clauses.get_conclusion goal)
                       then
                          Option.SOME (cl, der_cl)
                       else
                          Option.NONE
                    end
                val (psi: (Contecteds.Clauses.T * Contecteds.Clauses.T) Option.option)
                  = ClauseSet.ofind
                       (omega: Contecteds.Clauses.T -> ((Contecteds.Clauses.T * Contecteds.Clauses.T) Option.option))
                       proof
             in
                case (psi) of
                   Option.NONE
                      => Option.NONE
                |  Option.SOME (cl: Contecteds.Clauses.T, der_cl: Contecteds.Clauses.T)
                      => let
                            val proof'
                              = if is_conventional
                                then
                                   proof
                                else
                                   ClauseSet.drop(cl, proof)
                         in Option.SOME (
                               (
                                     Contecteds.MultiClauses.construct (
                                           (Contecteds.Clauses.get_context goal)
                                        ,  (Contecteds.Clauses.get_antecedent goal)
                                        ,  (
                                                 Contecteds.Literals.fop
                                                    (
                                                       fn (g: Contecteds.Literals.Single.T)
                                                       => let
                                                             val premis =  Contecteds.Clauses.construct (
                                                                   (Contecteds.Clauses.get_context goal)
                                                                ,  (Contecteds.Clauses.get_antecedent goal)
                                                                ,  g )
                                                          in
                                                             Contecteds.MultiClauses.get_conclusion (apply_in_both_manners is_conventional proof' premis)
                                                          end )
                                                    (Contecteds.Clauses.get_antecedent der_cl) ))))
                         end
            end
      and apply_in_both_manners is_conventional (proof: Proof) (goal: Contecteds.Clauses.T)
        = case(apply_telling_progress is_conventional proof goal) of
             Option.NONE =>  (Contecteds.multi_fe goal)
          |  Option.SOME result =>  result

      fun multi_apply_in_both_manners is_conventional (proof: Proof) (goal: Contecteds.MultiClauses.T)
        = Contecteds.MultiClauses.construct (
                (Contecteds.MultiClauses.get_context goal)
             ,  (Contecteds.MultiClauses.get_antecedent goal)
             ,  (
                   Contecteds.Literals.fop
                      (
                         fn (g: Contecteds.Literals.Single.T)
                         => let
                               val premis
                                 = Contecteds.Clauses.construct (
                                       (Contecteds.MultiClauses.get_context goal)
                                    ,  (Contecteds.MultiClauses.get_antecedent goal)
                                    ,  g )
                            in
                               Contecteds.MultiClauses.get_conclusion (apply_in_both_manners is_conventional proof premis)
                            end )
                   (Contecteds.MultiClauses.get_conclusion goal) ))

      val apply =  apply_in_both_manners false
      val multi_apply =  multi_apply_in_both_manners false
      val apply_conventionally =  apply_in_both_manners true
      val multi_apply_conventionally =  multi_apply_in_both_manners true
      fun add_clause_to_proof(cl: Contecteds.Clauses.T, proof: Proof) =  ClauseSet.insert(cl, proof)
      fun add_multi_clause_to_proof (mcl: Contecteds.MultiClauses.T, proof: Proof)
       =  Contecteds.clause_transition (
             fn (cl: Contecteds.Clauses.T, b: Proof)
             => Option.SOME (add_clause_to_proof(cl, b)) )
             mcl
             proof

      fun mini_complete (proof: Proof)
        = case (ClauseSet.getItem proof) of
             Option.NONE =>  proof
          |  Option.SOME (cl: Contecteds.Clauses.T, p_1: Proof)
             => let
                   val p_2 =  mini_complete p_1
                in
                   case (apply_telling_progress false p_2 cl) of
                      Option.NONE =>  ClauseSet.adjunct(cl, p_2)
                   |  Option.SOME (mcl: Contecteds.MultiClauses.T)
                      => if (Contecteds.MultiClauses.is_empty mcl)
                         then
                            p_2
                         else
                            let
                               val p_3 =  add_multi_clause_to_proof(mcl, p_2)
                            in
                               mini_complete p_3
                            end
                end
   end;
