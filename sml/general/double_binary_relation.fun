use "general/binary_relation.sig";
use "general/double_binary_relation.sig";
use "general/pair_type.sig";

functor DoubleBinaryRelation(X:
   sig
      structure FstRelation: BinaryRelation
      structure SndRelation: BinaryRelation
      structure Pair: PairType
      sharing Pair.FstType = FstRelation.Relation
      sharing Pair.SndType = SndRelation.Relation
   end ): DoubleBinaryRelation =
   struct
      structure FstRelation =  X.FstRelation
      structure SndRelation =  X.SndRelation
      structure Pair =  X.Pair
      structure Domain =
         struct
            structure FstStruct =  X.FstRelation.Domain
            structure SndStruct =  X.SndRelation.Domain
         end

      structure Relation =  Pair

   end;
