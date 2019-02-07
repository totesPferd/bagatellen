use "collections/eqs.sig";
use "logics/contecteds.sig";

signature Proof =
   sig
      structure Contecteds: Contecteds

      type Proof
      val apply: Proof -> Contecteds.Clauses.T -> Contecteds.MultiClauses.T
      val multi_apply: Proof -> Contecteds.MultiClauses.T -> Contecteds.MultiClauses.T
      val apply_conventionally: Proof -> Contecteds.Clauses.T -> Contecteds.MultiClauses.T
      val multi_apply_conventionally: Proof -> Contecteds.MultiClauses.T -> Contecteds.MultiClauses.T

   end;
