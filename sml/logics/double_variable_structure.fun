use "general/double_binary_relation.sig";
use "logics/variable_structure.sig";

functor DoubleVariableStructure(X:
   sig
      structure Fst: VariableStructure
      structure Snd: VariableStructure
      structure BinaryRelation: DoubleBinaryRelation
      sharing BinaryRelation.FstRelation =  Fst.BinaryRelation
      sharing BinaryRelation.SndRelation =  Snd.BinaryRelation
   end ): VariableStructure =
   struct
      structure Variables =
         struct
            structure Fst =  X.Fst
            structure Snd =  X.Snd
         end
      structure BinaryRelation =  X.BinaryRelation

      val eq =  X.BinaryRelation.Pair.tuple (
            X.Fst.eq
         ,  X.Snd.eq )

   end;
