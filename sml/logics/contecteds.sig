use "collections/type.sig";
use "logics/literals.sig";
use "logics/variables.sig";
use "logics/variable_contexts.sig";

signature Contecteds =
   sig
      structure Literals: Literals
      structure VariableContexts: VariableContexts
      sharing Literals.Variables = VariableContexts.Variables
      structure Clauses:
         sig
            structure Literals: Literals
            structure VariableContexts: VariableContexts
            type T
            val eq: T * T -> bool
            val get_context: T -> VariableContexts.VariableContext.T
            val get_antecedent: T -> Literals.Multi.T
            val get_conclusion: T -> Literals.Single.T
            val construct: VariableContexts.VariableContext.T * Literals.Multi.T * Literals.Single.T  -> T
            val apply_alpha_conversion: VariableContexts.AlphaConverter -> T -> T

            val is_assumption: T -> bool
         end
      structure MultiClauses:
         sig
            structure Literals: Literals
            structure VariableContexts: VariableContexts
            type T
            val eq: T * T -> bool
            val get_context: T -> VariableContexts.VariableContext.T
            val get_antecedent: T -> Literals.Multi.T
            val get_conclusion: T -> Literals.Multi.T
            val construct: VariableContexts.VariableContext.T * Literals.Multi.T * Literals.Multi.T  -> T
            val apply_alpha_conversion: VariableContexts.AlphaConverter -> T -> T

            val is_empty: T -> bool
            val is_assumption: T -> bool
         end
      structure Antecedents:
         sig
            structure Literals: Literals
            structure VariableContexts: VariableContexts
            type T
            val eq: T * T -> bool
            val get_context: T -> VariableContexts.VariableContext.T
            val get_antecedent: T -> Literals.Multi.T
            val construct: VariableContexts.VariableContext.T * Literals.Multi.T -> T
            val apply_alpha_conversion: VariableContexts.AlphaConverter -> T -> T
            val empty: VariableContexts.VariableContext.T -> T

            val is_empty: T -> bool
         end
      structure Conclusions:
         sig
            structure Literals: Literals
            structure VariableContexts: VariableContexts
            type T
            val eq: T * T -> bool
            val get_context: T -> VariableContexts.VariableContext.T
            val get_conclusion: T -> Literals.Single.T
            val construct: VariableContexts.VariableContext.T * Literals.Single.T  -> T
            val apply_alpha_conversion: VariableContexts.AlphaConverter -> T -> T
            val equate: T * T -> bool
         end
      sharing Antecedents.Literals =  Literals
      sharing Clauses.Literals =  Literals
      sharing Conclusions.Literals =  Literals
      sharing MultiClauses.Literals =  Literals
      sharing Antecedents.VariableContexts =  VariableContexts
      sharing Clauses.VariableContexts =  VariableContexts
      sharing Conclusions.VariableContexts =  VariableContexts
      sharing MultiClauses.VariableContexts =  VariableContexts

      val make_clause_from_conclusion: Conclusions.T -> Clauses.T
      val make_multi_clause_from_antecedent: Antecedents.T -> MultiClauses.T
      val empty_multi_clause: Antecedents.T -> MultiClauses.T
      val get_antecedent: Clauses.T -> Antecedents.T
      val get_conclusion: Clauses.T -> Conclusions.T
      val multi_get_antecedent: MultiClauses.T -> Antecedents.T
      val multi_get_conclusion: MultiClauses.T -> Antecedents.T

      val fe:  Conclusions.T -> Antecedents.T
      val multi_fe:  Clauses.T -> MultiClauses.T

      val transition: (Conclusions.T * 'b -> 'b Option.option) -> Antecedents.T -> 'b -> 'b
      val clause_transition: (Clauses.T * 'b -> 'b Option.option) -> MultiClauses.T -> 'b -> 'b

   end;
