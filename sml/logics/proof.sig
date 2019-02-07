use "collections/eqs.sig";
use "logics/contecteds.sig";

signature Proof =
   sig
      structure Contecteds: Contecteds

      type Proof
      val apply:                      Proof -> Contecteds.Clauses.T -> Contecteds.MultiClauses.T
      val multi_apply:                Proof -> Contecteds.MultiClauses.T -> Contecteds.MultiClauses.T
      val apply_conventionally:       Proof -> Contecteds.Clauses.T -> Contecteds.MultiClauses.T
      val multi_apply_conventionally: Proof -> Contecteds.MultiClauses.T -> Contecteds.MultiClauses.T
      val add_clause_to_proof:        Contecteds.Clauses.T * Proof -> Proof
      val add_multi_clause_to_proof:  Contecteds.MultiClauses.T * Proof -> Proof
      val mini_complete:              Proof -> Proof

   end;
