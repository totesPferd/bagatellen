use "general/type.sig";

signature PointeredType =
   sig
      structure BaseType: Type
      structure ContainerType: Type
      structure PointerType: Type

      val empty:     ContainerType.T
      val is_empty:  ContainerType.T -> bool
      val select:    PointerType.T * ContainerType.T -> BaseType.T Option.option
      val singleton: PointerType.T * BaseType.T -> ContainerType.T

   end;
