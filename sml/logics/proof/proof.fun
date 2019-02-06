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

      fun apply_telling_progress (proof: Proof) (goal: Contecteds.Clauses.T)
        = if Contecteds.Clauses.is_assumption goal
          then
             (false, Contecteds.empty_multi_clause (Contecteds.get_antecedent goal))
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
                      => (false, Contecteds.multi_fe goal)
                |  Option.SOME (cl: Contecteds.Clauses.T, der_cl: Contecteds.Clauses.T)
                      => (
                               true
                            ,  (
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
                                                             Contecteds.MultiClauses.get_conclusion (apply proof premis)
                                                          end )
                                                    (Contecteds.Clauses.get_antecedent der_cl) ))))
            end
      and apply (proof: Proof) (goal: Contecteds.Clauses.T)
        = let
             val (progress, result) =  apply_telling_progress proof goal
          in
             result
          end
      and multi_apply (proof: Proof) (goal: Contecteds.MultiClauses.T)
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
                               Contecteds.MultiClauses.get_conclusion (apply proof premis)
                            end )
                   (Contecteds.MultiClauses.get_conclusion goal) ))
   end;
