use "general/double_binary_relation.sig";
use "general/double_map.sig";
use "general/sum_type.sig";
use "logics/variable_structure.sig";

signature DoubleVariableStructure =
   sig
      structure Variables:
         sig
            structure Fst: VariableStructure
            structure Snd: VariableStructure
         end
      structure BaseType: SumType
      structure BinaryRelation: DoubleBinaryRelation
      structure Map: DoubleMap
      sharing BinaryRelation.Domain = Variables
      sharing BinaryRelation.FstRelation =  Variables.Fst.BinaryRelation
      sharing BinaryRelation.SndRelation =  Variables.Snd.BinaryRelation
      sharing Map.Start = Variables
      sharing Map.End = Variables
      sharing Map.FstMap = Variables.Fst.Map
      sharing Map.SndMap = Variables.Snd.Map
      sharing BaseType.FstType = Variables.Fst.BaseType
      sharing BaseType.SndType = Variables.Snd.BaseType

      val copy: Map.Map.T
      val eq:   BinaryRelation.Relation.T
   end;
