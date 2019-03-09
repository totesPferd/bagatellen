use "general/type_binary_relation.sig";

signature BaseBinaryRelation =
   sig
      include TypeBinaryRelation

      val get_binary_relation: (Domain.T * Domain.T -> bool) -> Relation.T

   end;
