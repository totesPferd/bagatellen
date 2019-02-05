use "collections/dictset.fun";
use "collections/sets.fun";
use "logics/clauses.sig";
use "logics/contected_literals.sig";
use "logics/literals.sig";
use "logics/proof.sig";
use "logics/variable_contexts.sig";

functor Proof(X:
   sig
      structure Clauses: Clauses
      structure CLits: ContectedLiterals
      sharing Clauses.Literals =  CLits.Literals
      sharing Clauses.VariableContexts =  CLits.VariableContexts
      sharing Clauses.Variables = CLits.Variables
   end ): Proof =
   struct
      structure Clauses =  X.Clauses
      structure CLits =  X.CLits

      structure ClauseDictSet =  DictSet(Clauses)
      structure CLitDictSet =  DictSet(CLits)

      structure ClauseSet =  Sets(ClauseDictSet)
      structure CLitSet =  Sets(CLitDictSet)

      type Proof =  ClauseSet.T

      fun apply (proof: Proof) (proof_state: CLitSet.T) (goal: CLits.T)
        = let
             fun omega (cl: Clauses.T)
               = let
                    val alpha =  Clauses.alpha_convert (fn x => x) cl
                    val der_cl =  Clauses.apply_alpha_conversion alpha cl
                 in
                    if Clauses.Literals.Single.equate((Clauses.get_conclusion der_cl), (CLits.get_conclusion goal))
                    then
                       Option.SOME (cl, der_cl)
                    else
                       Option.NONE
                 end
             val (psi: (Clauses.T * Clauses.T) Option.option)
               = ClauseSet.ofind
                    (omega: Clauses.T -> ((Clauses.T * Clauses.T) Option.option))
                    proof
          in
             case (psi) of
                Option.NONE
                   => (false, CLitSet.insert(goal, proof_state))
             |  Option.SOME (cl: Clauses.T, der_cl: Clauses.T)
                   => (
                            true
                          , Clauses.Literals.transition
                               (
                                  fn (premis: Clauses.Literals.Single.T, ps: CLitSet.T)
                                     => Option.SOME (
                                           let
                                              val (progress, result)
                                                = apply
                                                    (ClauseSet.drop(cl, proof))
                                                    ps
                                                    (CLits.get_t(CLits.get_context goal, premis))
                                           in
                                              result
                                           end ))
                               (Clauses.get_antecedent der_cl)
                               proof_state )
          end
   end;
