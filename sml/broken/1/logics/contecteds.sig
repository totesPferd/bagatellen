use "general/type.sig";
use "logics/constructors.sig";
use "logics/literals.sig";
use "logics/variable_contexts.sig";
use "logics/variables.sig";

signature Contecteds =
   sig
      structure Constructors: Constructors
      structure Literals: Literals
      structure VariableContexts: VariableContexts
      sharing Literals.Constructors =  Constructors
      sharing Literals.VariableStructure = VariableContexts.VariableStructure
      structure Clauses:
         sig
            structure Single:
               sig
                  type T
                  val eq: T * T -> bool
                  val get_context: T -> VariableContexts.VariableContext.T
                  val get_antecedent: T -> Literals.Multi.T
                  val get_conclusion: T -> Literals.Single.T
                  val construct: VariableContexts.VariableContext.T * Literals.Multi.T * Literals.Single.T  -> T
                  val apply_alpha_conversion: VariableContexts.AlphaConverter -> T -> T
                  val get_occurences: T -> Literals.Occurences.T

                  val is_assumption: T -> bool
               end
            structure Multi:
               sig
                  type T
                  val eq: T * T -> bool
                  val get_context: T -> VariableContexts.VariableContext.T
                  val get_antecedent: T -> Literals.Multi.T
                  val get_conclusion: T -> Literals.Multi.T
                  val construct: VariableContexts.VariableContext.T * Literals.Multi.T * Literals.Multi.T  -> T
                  val apply_alpha_conversion: VariableContexts.AlphaConverter -> T -> T
                  val get_occurences: T -> Literals.Occurences.T

                  val is_empty: T -> bool
                  val is_assumption: T -> bool
               end
            val transition: (Single.T * 'b -> 'b Option.option) -> Multi.T -> 'b -> 'b
         end
      structure ContectedLiterals:
         sig
            structure Single:
               sig
                  type T
                  val eq: T * T -> bool
                  val get_context: T -> VariableContexts.VariableContext.T
                  val get_conclusion: T -> Literals.Single.T
                  val construct: VariableContexts.VariableContext.T * Literals.Single.T  -> T
                  val apply_alpha_conversion: VariableContexts.AlphaConverter -> T -> T
                  val get_occurences: T -> Literals.Occurences.T
                  val equate: T * T -> bool
               end
            structure Multi:
               sig
                  type T
                  val eq: T * T -> bool
                  val get_context: T -> VariableContexts.VariableContext.T
                  val get_antecedent: T -> Literals.Multi.T
                  val construct: VariableContexts.VariableContext.T * Literals.Multi.T -> T
                  val apply_alpha_conversion: VariableContexts.AlphaConverter -> T -> T
                  val get_occurences: T -> Literals.Occurences.T
                  val empty: VariableContexts.VariableContext.T -> T

                  val is_empty: T -> bool
               end
            val transition: (Single.T * 'b -> 'b Option.option) -> Multi.T -> 'b -> 'b
         end

      val make_clause_from_conclusion: ContectedLiterals.Single.T -> Clauses.Single.T
      val make_multi_clause_from_antecedent: ContectedLiterals.Multi.T -> Clauses.Multi.T
      val empty_multi_clause: ContectedLiterals.Multi.T -> Clauses.Multi.T
      val get_antecedent: Clauses.Single.T -> ContectedLiterals.Multi.T
      val get_conclusion: Clauses.Single.T -> ContectedLiterals.Single.T
      val multi_get_antecedent: Clauses.Multi.T -> ContectedLiterals.Multi.T
      val multi_get_conclusion: Clauses.Multi.T -> ContectedLiterals.Multi.T

   end;
