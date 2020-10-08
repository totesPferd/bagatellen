use "general/binary_relation.sig";
use "general/pair_type.sig";

signature DoubleBinaryRelation =
   sig
      include BinaryRelation
      structure FstRelation: BinaryRelation
      structure SndRelation: BinaryRelation
      structure Pair: PairType
      sharing Pair = Relation
      sharing Pair.FstType = FstRelation.Relation
      sharing Pair.SndType = SndRelation.Relation
   end;
