use "general/double_binary_relation.sig";
use "general/double_map.sig";
use "general/sum_type.sig";
use "logics/double_variable_structure.sig";
use "logics/variable_structure.sig";

functor DoubleVariableStructure(X:
   sig
      structure Fst: VariableStructure
      structure Snd: VariableStructure
      structure BinaryRelation: DoubleBinaryRelation
      structure Map: DoubleMap
      structure Type: SumType
      sharing BinaryRelation.FstRelation =  Fst.BinaryRelation
      sharing BinaryRelation.SndRelation =  Snd.BinaryRelation
      sharing Map.FstMap = Fst.Map
      sharing Map.SndMap = Snd.Map
      sharing Type.FstType = Fst.Type
      sharing Type.SndType = Snd.Type
   end ): DoubleVariableStructure =
   struct
      structure Variables =
         struct
            structure Fst =  X.Fst
            structure Snd =  X.Snd
         end
      structure BinaryRelation =  X.BinaryRelation
      structure Map =  X.Map
      structure Type =  X.Type

      val copy =  X.Map.Pair.tuple (
            X.Fst.copy
         ,  X.Snd.copy )
      val eq =  X.BinaryRelation.Pair.tuple (
            X.Fst.eq
         ,  X.Snd.eq )

   end;
