use "collections/dictset.fun";
use "collections/sets.fun";
use "logics/literals.sig";
use "logics/proof.sig";
use "logics/variable_contexts.sig";

functor Proof(X:
   sig
      structure Lit: Literals
      structure VC: VariableContexts
      sharing Lit.Variables = VC.Variables
   end ): Proof =
   struct
      structure Literals =  X.Lit
      structure VariableContexts =  X.VC
      structure Clause =  Literals.Clause
      structure ClauseDictSet =  DictSet(Clause)
      structure ClauseSet =  Sets(ClauseDictSet)
      structure LiteralDictSet =  DictSet(Literals.Single)
      structure LiteralSet =  Sets(LiteralDictSet)
      structure CVDT =  Clause:VariablesDependingThing

      type Proof =  { context: VariableContexts.VariableContext.T, clauses: ClauseSet.T }

      fun apply (proof: Proof) (proof_state: LiteralSet.T) (goal: Literals.Single.T)
        = let
             val alpha =  VariableContexts.alpha_convert (fn x => x) (#context proof)
             fun omega cl
               = let
                    val der_cl =  Clause.vmap (VariableContexts.apply_alpha_converter alpha) cl
                 in
                    if Literals.Single.equate((#conclusion der_cl), goal)
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
                   => Literals.transition
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
