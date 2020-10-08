use "collections/all_zip.sig";
use "general/pair_type.sig";
use "pointered_types/double_pointered_type.sig";

functor DoubleAllZip(X:
   sig
      structure Fst: AllZip
      structure Snd: AllZip
      structure RelationPair: PairType
      structure DoublePointeredType: DoublePointeredType
      sharing RelationPair.FstType =  Fst.BinaryRelation.Relation
      sharing RelationPair.SndType =  Snd.BinaryRelation.Relation
      sharing DoublePointeredType.FstType =  Fst.PointeredType
      sharing DoublePointeredType.SndType =  Snd.PointeredType
   end ): AllZip =
   struct
      structure BinaryRelation: BinaryRelation =
         struct
            structure Domain =
               struct
                  structure FstStruct =  X.Fst.BinaryRelation.Domain
                  structure SndStruct =  X.Snd.BinaryRelation.Domain
               end

            structure Relation =  X.RelationPair
         end
      structure PointeredType =  X.DoublePointeredType

      fun result r (c_1, c_2)
         =     X.Fst.result (X.RelationPair.fst r) (X.DoublePointeredType.ContainerType.fst c_1, X.DoublePointeredType.ContainerType.fst c_2)
            andalso
               X.Snd.result (X.RelationPair.snd r) (X.DoublePointeredType.ContainerType.snd c_1, X.DoublePointeredType.ContainerType.snd c_2)

   end;

