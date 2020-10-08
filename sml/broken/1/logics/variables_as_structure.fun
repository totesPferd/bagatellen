use "general/base_binary_relation.sig";
use "general/base_map.sig";
use "logics/variable_structure.sig";
use "logics/variables.sig";

functor VariableAsStructure(X:
   sig
      structure Variables: Variables
      structure BinaryRelation: BaseBinaryRelation
      structure Map: BaseMap
      sharing BinaryRelation.Domain =  Variables
      sharing Map.Start =  Variables
      sharing Map.End =  Variables
   end ): VariableStructure =
   struct
      structure BinaryRelation =  X.BinaryRelation
      structure Map =  X.Map
      structure Variables =  X.Variables
      structure BaseType =  X.Variables.Base.Single
      structure VarType =  X.Variables

      val copy =  Map.get_map(Variables.copy)
      val eq =  BinaryRelation.get_binary_relation(Variables.eq)

   end;
