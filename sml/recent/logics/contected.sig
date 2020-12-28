use "logics/contected_multi_clause.sig";
use "logics/contected_multi_literal.sig";
use "logics/contected_single_clause.sig";
use "logics/contected_single_literal.sig";

signature Contected =
   sig
      structure Literal:
         sig
            structure Single: ContectedSingleLiteral
            structure Multi: ContectedMultiLiteral
         end
      structure Clause:
         sig
            structure Single: ContectedSingleClause
            structure Multi: ContectedMultiClause
         end

      val make_clause_from_conclusion: Literal.Single.T -> Clause.Single.T
      val make_multi_clause_from_antecedent: Literal.Multi.T -> Clause.Multi.T
      val empty_multi_clause: Literal.Multi.T -> Clause.Multi.T
      val single_get_antecedent: Clause.Single.T -> Literal.Multi.T
      val single_get_conclusion: Clause.Single.T -> Literal.Single.T
      val multi_get_antecedent: Clause.Multi.T -> Literal.Multi.T
      val multi_get_conclusion: Clause.Multi.T -> Literal.Multi.T

   end
