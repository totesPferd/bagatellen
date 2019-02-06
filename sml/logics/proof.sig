use "collections/eqs.sig";
use "logics/contecteds.sig";

signature Proof =
   sig
      structure Contecteds: Contecteds

      type Proof
      val apply: Proof -> Contecteds.Clauses.T -> bool * Contecteds.MultiClauses.T

   end;
