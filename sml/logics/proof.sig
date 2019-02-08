use "collections/eqs.sig";
use "logics/contecteds.sig";

signature Proof =
   sig
      structure Contecteds: Contecteds

      type Proof
      val apply:                      Proof -> Contecteds.Clauses.Single.T -> Contecteds.Clauses.Multi.T
      val multi_apply:                Proof -> Contecteds.Clauses.Multi.T -> Contecteds.Clauses.Multi.T
      val apply_conventionally:       Proof -> Contecteds.Clauses.Single.T -> Contecteds.Clauses.Multi.T
      val multi_apply_conventionally: Proof -> Contecteds.Clauses.Multi.T -> Contecteds.Clauses.Multi.T
      val add_clause_to_proof:        Contecteds.Clauses.Single.T * Proof -> Proof
      val add_multi_clause_to_proof:  Contecteds.Clauses.Multi.T * Proof -> Proof
      val mini_complete:              Proof -> Proof

   end;
