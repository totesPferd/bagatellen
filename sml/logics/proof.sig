use "collections/sets.sig";
use "logics/literals.sig";

signature Proof =
   sig
      structure Literals: Literals
      structure LiteralSet:  Sets
      sharing LiteralSet.Eqs = Literals

      type Proof
      val apply : Proof -> LiteralSet.T -> Literals.T -> LiteralSet.T
   end;
