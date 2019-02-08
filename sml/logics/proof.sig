use "collections/type.sig";
use "logics/contecteds.sig";

signature Proof =
   sig
      structure Contecteds: Contecteds
      structure Single: Type
      structure Multi: Type
      sharing Contecteds.Clauses.Single =  Single

      val apply:                      Multi.T -> Contecteds.Clauses.Single.T -> Contecteds.Clauses.Multi.T
      val multi_apply:                Multi.T -> Contecteds.Clauses.Multi.T -> Contecteds.Clauses.Multi.T
      val apply_conventionally:       Multi.T -> Contecteds.Clauses.Single.T -> Contecteds.Clauses.Multi.T
      val multi_apply_conventionally: Multi.T -> Contecteds.Clauses.Multi.T -> Contecteds.Clauses.Multi.T
      val add_clause_to_proof:        Contecteds.Clauses.Single.T * Multi.T -> Multi.T
      val add_multi_clause_to_proof:  Contecteds.Clauses.Multi.T * Multi.T -> Multi.T
      val mini_complete:              Multi.T -> Multi.T

   end;
