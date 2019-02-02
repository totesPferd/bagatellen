use "collections/dictset.fun";
use "collections/sets.fun";
use "logics/literal_sets.sig";
use "logics/literal_sets/clause_extract.fun";
use "logics/proof.sig";
use "logics/variable_contexts.sig";

functor Proof(X:
   sig
      structure LS: LiteralSets
      structure VC: VariableContexts
      sharing LS.Variables = VC.Variables
   end ): Proof =
   struct
      structure LiteralSets =  X.LS
      structure Literals =  LiteralSets.Literals
      structure VariableContexts =  X.VC
      structure Clause =  ClauseExtract(X.LS)
      structure ClauseDictSet =  DictSet(Clause)
      structure ClauseSet =  Sets(ClauseDictSet)
      structure LiteralDictSet =  DictSet(Literals)
      structure LiteralSet =  Sets(LiteralDictSet)
      structure CVDT =  Clause:VariablesDependingThing

      type Proof =  { context: VariableContexts.VariableContext.T, clauses: ClauseSet.T }

      fun apply (proof: Proof) (proof_state: LiteralSet.T) (goal: Literals.T)
        = let
             val alpha =  VariableContexts.alpha_convert (fn x => x) (#context proof)
             fun omega cl
               = let
                    val der_cl =  Clause.vmap (VariableContexts.apply_alpha_converter alpha) cl
                 in
                    if Literals.equate((#conclusion der_cl), goal)
                    then
                       Option.SOME (cl, der_cl)
                    else
                       Option.NONE
                 end
             val psi
               = ClauseSet.ofind
                    omega
                    (#clauses proof)
          in
             case (psi) of
                Option.NONE
                   => LiteralSet.insert(goal, proof_state)
             |  Option.SOME (cl, der_cl)
                   => LiteralSets.transition
                         (
                            fn (premis, ps)
                               => Option.SOME (
                                     apply
                                        { context = (#context proof), clauses = ClauseSet.drop(cl, (#clauses proof)) }
                                        ps
                                        premis ))
                         (#antecedent der_cl)
                         proof_state
          end

   end;
