use "collections/dictset.fun";
use "collections/sets.fun";
use "logics/contecteds.sig";
use "logics/literals.sig";
use "logics/proof.sig";
use "logics/variable_contexts.sig";

functor Proof(X: Contecteds): Proof =
   struct
      structure Contecteds =  X

      structure ClauseDictSet =  DictSet(Contecteds.Clauses.Single)
      structure ClauseSet =  Sets(ClauseDictSet)

      type Proof =  ClauseSet.T

      fun apply_telling_progress is_conventional (proof: Proof) (goal: Contecteds.Clauses.Single.T)
        = if Contecteds.Clauses.Single.is_assumption goal
          then
             Option.SOME (Contecteds.empty_multi_clause (Contecteds.get_antecedent goal))
          else
             let
                fun omega (cl: Contecteds.Clauses.Single.T)
                  = let
                       val ctxt =  Contecteds.Clauses.Single.get_context cl
                       val alpha =  Contecteds.VariableContexts.alpha_convert (fn x => x) ctxt
                       val der_cl =  Contecteds.Clauses.Single.apply_alpha_conversion alpha cl
                    in
                       if Contecteds.Literals.Single.equate(Contecteds.Clauses.Single.get_conclusion der_cl, Contecteds.Clauses.Single.get_conclusion goal)
                       then
                          Option.SOME (cl, der_cl)
                       else
                          Option.NONE
                    end
                val (psi: (Contecteds.Clauses.Single.T * Contecteds.Clauses.Single.T) Option.option)
                  = ClauseSet.ofind
                       (omega: Contecteds.Clauses.Single.T -> ((Contecteds.Clauses.Single.T * Contecteds.Clauses.Single.T) Option.option))
                       proof
             in
                case (psi) of
                   Option.NONE
                      => Option.NONE
                |  Option.SOME (cl: Contecteds.Clauses.Single.T, der_cl: Contecteds.Clauses.Single.T)
                      => let
                            val proof'
                              = if is_conventional
                                then
                                   proof
                                else
                                   ClauseSet.drop(cl, proof)
                         in Option.SOME (
                               (
                                     Contecteds.Clauses.Multi.construct (
                                           (Contecteds.Clauses.Single.get_context goal)
                                        ,  (Contecteds.Clauses.Single.get_antecedent goal)
                                        ,  (
                                                 Contecteds.Literals.fop
                                                    (
                                                       fn (g: Contecteds.Literals.Single.T)
                                                       => let
                                                             val premis =  Contecteds.Clauses.Single.construct (
                                                                   (Contecteds.Clauses.Single.get_context goal)
                                                                ,  (Contecteds.Clauses.Single.get_antecedent goal)
                                                                ,  g )
                                                          in
                                                             Contecteds.Clauses.Multi.get_conclusion (apply_in_both_manners is_conventional proof' premis)
                                                          end )
                                                    (Contecteds.Clauses.Single.get_antecedent der_cl) ))))
                         end
            end
      and apply_in_both_manners is_conventional (proof: Proof) (goal: Contecteds.Clauses.Single.T)
        = case(apply_telling_progress is_conventional proof goal) of
             Option.NONE =>  (Contecteds.Clauses.fe goal)
          |  Option.SOME result =>  result

      fun multi_apply_in_both_manners is_conventional (proof: Proof) (goal: Contecteds.Clauses.Multi.T)
        = Contecteds.Clauses.Multi.construct (
                (Contecteds.Clauses.Multi.get_context goal)
             ,  (Contecteds.Clauses.Multi.get_antecedent goal)
             ,  (
                   Contecteds.Literals.fop
                      (
                         fn (g: Contecteds.Literals.Single.T)
                         => let
                               val premis
                                 = Contecteds.Clauses.Single.construct (
                                       (Contecteds.Clauses.Multi.get_context goal)
                                    ,  (Contecteds.Clauses.Multi.get_antecedent goal)
                                    ,  g )
                            in
                               Contecteds.Clauses.Multi.get_conclusion (apply_in_both_manners is_conventional proof premis)
                            end )
                   (Contecteds.Clauses.Multi.get_conclusion goal) ))

      val apply =  apply_in_both_manners false
      val multi_apply =  multi_apply_in_both_manners false
      val apply_conventionally =  apply_in_both_manners true
      val multi_apply_conventionally =  multi_apply_in_both_manners true
      fun add_clause_to_proof(cl: Contecteds.Clauses.Single.T, proof: Proof) =  ClauseSet.insert(cl, proof)
      fun add_multi_clause_to_proof (mcl: Contecteds.Clauses.Multi.T, proof: Proof)
       =  Contecteds.Clauses.transition (
             fn (cl: Contecteds.Clauses.Single.T, b: Proof)
             => Option.SOME (add_clause_to_proof(cl, b)) )
             mcl
             proof

      fun mini_complete (proof: Proof)
        = case (ClauseSet.getItem proof) of
             Option.NONE =>  proof
          |  Option.SOME (cl: Contecteds.Clauses.Single.T, p_1: Proof)
             => let
                   val p_2 =  mini_complete p_1
                in
                   case (apply_telling_progress false p_2 cl) of
                      Option.NONE =>  ClauseSet.adjunct(cl, p_2)
                   |  Option.SOME (mcl: Contecteds.Clauses.Multi.T)
                      => if (Contecteds.Clauses.Multi.is_empty mcl)
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
