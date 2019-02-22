use "general/map.sig";
use "general/type.sig";

signature PointeredType =
   sig
      structure BaseType: Type
      structure ContainerType: Type
      structure PointerType: Type
      structure SelectMap: Map
      structure SingletonMap: Map
      sharing SelectMap.Start = ContainerType
      sharing SelectMap.End = BaseType
      sharing SingletonMap.Start = BaseType
      sharing SingletonMap.End = ContainerType

      val empty:     ContainerType.T
      val select:    PointerType.T -> SelectMap.T Option.option
      val singleton: PointerType.T -> SingletonMap.T

   end;
