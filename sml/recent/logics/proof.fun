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
                   in X.C.Literal.lift
                         (apply_to_literal_telling_progress is_conventional proof')
                         antecedent
                   end
          end

   end
