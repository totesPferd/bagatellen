use "general/binary_relation.sig";

signature VariableStructure =
   sig
      structure Variables:
         sig
         end
      structure BinaryRelation: BinaryRelation
      sharing BinaryRelation.Domain =  Variables

      val eq:  BinaryRelation.Relation.T
   end;
