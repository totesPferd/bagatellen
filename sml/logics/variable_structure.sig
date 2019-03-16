use "general/binary_relation.sig";
use "general/map.sig";
use "general/type.sig";

signature VariableStructure =
   sig
      structure Variables:
         sig
         end
      structure Type: Type
      structure BinaryRelation: BinaryRelation
      structure Map: Map
      sharing BinaryRelation.Domain = Variables
      sharing Map.Start = Variables
      sharing Map.End = Variables

      val copy: Map.Map.T
      val eq:   BinaryRelation.Relation.T
   end;
