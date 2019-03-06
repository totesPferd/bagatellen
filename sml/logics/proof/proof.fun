use "collections/dictset.fun";
use "general/type.sig";
use "logics/contecteds.sig";
use "logics/literals.sig";
use "logics/proof.sig";
use "logics/variable_contexts.sig";
use "pointered_types/pointered_base_map.sig";
use "pointered_types/pointered_generation.sig";

functor Proof(X:
   sig
      structure Contecteds: Contecteds
      structure PointeredBaseMap: PointeredBaseMap
      structure PointerType: Type
      structure PointeredGeneration: PointeredGeneration
      sharing PointeredGeneration.Start =  Contecteds.Literals.PointeredTypeExtended
      sharing PointeredGeneration.End =  Contecteds.Literals.PointeredTypeExtended
      sharing PointeredGeneration.PointeredMap =  PointeredBaseMap
      sharing PointeredBaseMap.Start =  Contecteds.Literals.PointeredTypeExtended.BaseType
      sharing PointeredBaseMap.End =  Contecteds.Literals.PointeredTypeExtended.ContainerType
      sharing PointeredBaseMap.PointerType =  PointerType
      sharing Contecteds.Literals.PointeredTypeExtended.PointerType =  PointerType
      sharing PointeredGeneration.Start.PointerType =  PointerType
   end ): Proof =
   struct
      structure Contecteds =  X.Contecteds
      structure Constructors =  Contecteds.Constructors
      structure Single =  Contecteds.Clauses.Single

      structure ClauseDictSet =  DictSet(Single)
      structure Multi =  ClauseDictSet.Sets

      fun apply_telling_progress is_conventional (proof: Multi.T) (goal: Single.T)
        = if Single.is_assumption goal
          then
             Option.SOME (Contecteds.empty_multi_clause (Contecteds.get_antecedent goal))
          else
             let
                fun omega (cl: Single.T)
                  = let
                       val ctxt =  Single.get_context cl
                       val alpha =  Contecteds.VariableContexts.alpha_convert ctxt
                       val der_cl =  Single.apply_alpha_conversion alpha cl
                    in
                       if Contecteds.Literals.Single.equate(Single.get_conclusion der_cl, Single.get_conclusion goal)
                       then
                          Option.SOME (cl, der_cl)
                       else
                          Option.NONE
                    end
                val (psi: (Single.T * Single.T) Option.option)
                  = Multi.ofind
                       (omega: Single.T -> ((Single.T * Single.T) Option.option))
                       proof
             in
                case (psi) of
                   Option.NONE
                      => Option.NONE
                |  Option.SOME (cl: Single.T, der_cl: Single.T)
                      => let
                            val proof'
                              = if is_conventional
                                then
                                   proof
                                else
                                   Multi.drop(cl, proof)
                         in Option.SOME (
                            Contecteds.Clauses.Multi.construct (
                                  (Single.get_context goal)
                               ,  (Single.get_antecedent goal)
                               ,  (
                                     X.PointeredGeneration.generate (
                                        X.PointeredBaseMap.get_map (
                                           fn (_, g: Contecteds.Literals.Single.T)
                                           => let
                                                 val premis =  Single.construct (
                                                       (Single.get_context goal)
                                                    ,  (Single.get_antecedent goal)
                                                    ,  g )
                                              in
                                                 Contecteds.Clauses.Multi.get_conclusion (apply_in_both_manners is_conventional proof' premis)
                                              end ))
                                        (Single.get_antecedent der_cl) )))
                         end
            end
      and apply_in_both_manners is_conventional (proof: Multi.T) (goal: Single.T)
        = case(apply_telling_progress is_conventional proof goal) of
             Option.NONE
             => let
                   val var_ctxt =  Contecteds.Clauses.Single.get_context(goal)
                   val antecedent =  Contecteds.Clauses.Single.get_antecedent(goal)
                   val conclusion =  Contecteds.Clauses.Single.get_conclusion(goal)
                   val multi_conclusion =  Contecteds.Literals.fe conclusion
                in Contecteds.Clauses.Multi.construct(var_ctxt, antecedent, multi_conclusion)
                end
          |  Option.SOME result =>  result

      fun multi_apply_in_both_manners is_conventional (proof: Multi.T) (goal: Contecteds.Clauses.Multi.T)
        = Contecteds.Clauses.Multi.construct (
                (Contecteds.Clauses.Multi.get_context goal)
             ,  (Contecteds.Clauses.Multi.get_antecedent goal)
             ,  (
                   X.PointeredGeneration.generate (
                      X.PointeredBaseMap.get_map (
                         fn (_, g: Contecteds.Literals.Single.T)
                         => let
                               val premis
                                 = Single.construct (
                                       (Contecteds.Clauses.Multi.get_context goal)
                                    ,  (Contecteds.Clauses.Multi.get_antecedent goal)
                                    ,  g )
                            in
                               Contecteds.Clauses.Multi.get_conclusion (apply_in_both_manners is_conventional proof premis)
                            end ))
                      (Contecteds.Clauses.Multi.get_conclusion goal) ))

      val apply =  apply_in_both_manners false
      val multi_apply =  multi_apply_in_both_manners false
      val apply_conventionally =  apply_in_both_manners true
      val multi_apply_conventionally =  multi_apply_in_both_manners true
      fun add_clause_to_proof(cl: Single.T, proof: Multi.T) =  Multi.insert(cl, proof)
      fun add_multi_clause_to_proof (mcl: Contecteds.Clauses.Multi.T, proof: Multi.T)
       =  Contecteds.Clauses.transition (
             fn (cl: Single.T, b: Multi.T)
             => Option.SOME (add_clause_to_proof(cl, b)) )
             mcl
             proof

      val combine_proofs =  Multi.union

      fun mini_complete (proof: Multi.T)
        = case (Multi.getItem proof) of
             Option.NONE =>  proof
          |  Option.SOME (cl: Single.T, p_1: Multi.T)
             => let
                   val p_2 =  mini_complete p_1
                in
                   case (apply_telling_progress false p_2 cl) of
                      Option.NONE =>  Multi.adjunct(cl, p_2)
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
      fun reduce_double_occurences (proof: Multi.T)
        = case (Multi.getItem proof) of
             Option.NONE =>  proof
          |  Option.SOME (cl: Single.T, p_1: Multi.T)
             => let
                   val p_2 =  reduce_double_occurences p_1
                in
                   case (apply_telling_progress false p_2 cl) of
                      Option.NONE =>  Multi.adjunct(cl, p_2)
                   |  Option.SOME (mcl: Contecteds.Clauses.Multi.T)
                      => if (Contecteds.Clauses.Multi.is_empty mcl)
                         then
                            p_2
                         else
                            Multi.adjunct(cl, p_2)
                end


      val fe =  Multi.fe
      val fop =  Multi.fop
      val is_in =  Multi.is_in

      val transition =  Multi.transition

   end;
