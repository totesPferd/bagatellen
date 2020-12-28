use "logics/contected_multi_clause.sig";
use "logics/contected_multi_literal.sig";
use "logics/contected_single_clause.sig";
use "logics/contected_single_literal.sig";
use "logics/literal.sig";

signature Contected =
   sig
      structure Literal: Literal

      structure ContectedLiteral:
         sig
            structure Single: ContectedSingleLiteral
            structure Multi: ContectedMultiLiteral
         end
      structure Clause:
         sig
            structure Single: ContectedSingleClause
            structure Multi: ContectedMultiClause
         end

      val make_clause_from_conclusion: ContectedLiteral.Single.T -> Clause.Single.T
      val make_multi_clause_from_antecedent: ContectedLiteral.Multi.T -> Clause.Multi.T
      val empty_multi_clause: ContectedLiteral.Multi.T -> Clause.Multi.T
      val single_get_antecedent: Clause.Single.T -> ContectedLiteral.Multi.T
      val single_get_conclusion: Clause.Single.T -> ContectedLiteral.Single.T
      val multi_get_antecedent: Clause.Multi.T -> ContectedLiteral.Multi.T
      val multi_get_conclusion: Clause.Multi.T -> ContectedLiteral.Multi.T

   end
