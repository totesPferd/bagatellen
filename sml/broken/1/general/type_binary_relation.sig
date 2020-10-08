use "general/type.sig";

signature TypeBinaryRelation =
   sig
      structure Domain: Type
      structure Relation: Type

      val apply: Relation.T -> Domain.T * Domain.T -> bool

   end;
