use "collections/sets.sig";
use "logics/literals.sig";

signature Proof =
   sig
      structure Literals: Literals
      structure LiteralSet: Sets
      sharing LiteralSet.Eqs = Literals.Out

      type Proof
      val apply : Proof -> LiteralSet.T -> Literals.Out.T -> LiteralSet.T
   end;
