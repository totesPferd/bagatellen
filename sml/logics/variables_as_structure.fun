use "general/base_binary_relation.sig";
use "logics/variable_structure.sig";
use "logics/variables.sig";

functor VariableAsStructure(X:
   sig
      structure Variables: Variables
      structure BinaryRelation: BaseBinaryRelation
      sharing BinaryRelation.Domain =  Variables
   end ): VariableStructure =
   struct
      structure BinaryRelation =  X.BinaryRelation
      structure Variables =  X.Variables

      val eq =  BinaryRelation.get_binary_relation(Variables.eq)

   end;
