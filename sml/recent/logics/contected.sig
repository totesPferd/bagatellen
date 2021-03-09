use "general/eq_type.sig";
use "logics/literal.sig";

signature Contected =
   sig
      structure Literal: Literal

      structure ContectedLiteral:
         sig
            structure Single:
               sig
                  include EqType
           
                  val get_context: T -> Literal.VariableContext.T
                  val alpha_transform: Literal.variableMap_t -> T -> T

                  val equate: T * T -> bool

                  val get_conclusion: T -> Literal.Single.T
                  val construct: Literal.VariableContext.T * Literal.Single.T -> T

               end

            structure Multi:
               sig
                  include EqType
           
                  val get_context: T -> Literal.VariableContext.T
                  val alpha_transform: Literal.variableMap_t -> T -> T

                  val equate: T * T -> bool

                  val get_antecedent: T -> Literal.Multi.T
                  val construct: Literal.VariableContext.T * Literal.Multi.T -> T
            
                  val empty: Literal.VariableContext.T -> T
                  val is_empty: T -> bool

               end

         end
      structure Clause:
         sig
            structure Single:
               sig
                  include EqType
           
                  val get_context: T -> Literal.VariableContext.T
                  val alpha_transform: Literal.variableMap_t -> T -> T

                  val get_antecedent: T -> Literal.Multi.T
                  val is_assumption: T -> bool

                  val get_conclusion: T -> Literal.Single.T
                  val construct: Literal.VariableContext.T * Literal.Multi.T * Literal.Single.T -> T

               end

            structure Multi:
               sig
                  include EqType
           
                  val get_context: T -> Literal.VariableContext.T
                  val alpha_transform: Literal.variableMap_t -> T -> T

                  val get_antecedent: T -> Literal.Multi.T
                  val is_assumption: T -> bool

                  val get_conclusion: T -> Literal.Multi.T
                  val construct: Literal.VariableContext.T * Literal.Multi.T * Literal.Multi.T -> T
            
                  val is_empty: T -> bool

               end

         end

      val make_clause_from_conclusion: ContectedLiteral.Single.T -> Clause.Single.T
      val make_multi_clause_from_antecedent: ContectedLiteral.Multi.T -> Clause.Multi.T
      val empty_multi_clause: ContectedLiteral.Multi.T -> Clause.Multi.T
      val single_get_antecedent: Clause.Single.T -> ContectedLiteral.Multi.T
      val single_get_conclusion: Clause.Single.T -> ContectedLiteral.Single.T
      val multi_get_antecedent: Clause.Multi.T -> ContectedLiteral.Multi.T
      val multi_get_conclusion: Clause.Multi.T -> ContectedLiteral.Multi.T

      val singleton: ContectedLiteral.Single.T -> ContectedLiteral.Multi.T

   end
