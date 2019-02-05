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
   end;
