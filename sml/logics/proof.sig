use "collections/eqs.sig";
use "collections/sets.sig";
use "logics/clauses.sig";
use "logics/contected_literals.sig";
use "logics/literals.sig";

signature Proof =
   sig
      structure CLits: ContectedLiterals
      structure CLitSet: Sets
      sharing CLitSet.Eqs = CLits

      type Proof
      val apply: Proof -> CLitSet.T -> CLits.T -> bool * CLitSet.T
   end;
