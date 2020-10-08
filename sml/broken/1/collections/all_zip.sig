use "general/binary_relation.sig";
use "pointered_types/pointered_type.sig";

signature AllZip =
   sig
      structure BinaryRelation: BinaryRelation
      structure PointeredType: PointeredType
      sharing BinaryRelation.Domain = PointeredType.BaseType

      val result: BinaryRelation.Relation.T -> PointeredType.ContainerType.T * PointeredType.ContainerType.T -> bool
   end;
