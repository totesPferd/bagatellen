use "collections/eqs.sig";
use "collections/sets.sig";
use "logics/clauses.sig";
use "logics/contected_literals.sig";
use "logics/literals.sig";

signature Proof =
   sig
      structure CLits: ContectedLiterals
      structure Clauses:  Clauses
      structure CLitSet: Sets
      sharing CLits.Literals =  Clauses.Literals
      sharing CLits.VariableContexts =  Clauses.VariableContexts
      sharing CLits.Variables =  Clauses.Variables
      sharing CLitSet.Eqs = CLits

      type Proof
      val apply: Proof -> CLitSet.T -> CLits.T -> bool * CLitSet.T

      val make_clause_from_contected_literal: CLits.T -> Clauses.T
      val get_contected_conclusion: Clauses.T -> CLits.T
      val add_assumption_to_proof: CLits.T -> Proof -> Proof

      val apply_proof_on_clause: Proof -> CLitSet.T -> Clauses.T -> bool * CLitSet.T

   end;
