use "collections/type.sig";

signature PointerType =
   sig
      structure BaseType: Type
      structure ContainerType: Type
      structure PointerType: Type

      val select: PointerType.T * ContainerType.T -> BaseType.T
      val fold: (BaseType.T * 'b -> 'b) -> 'b -> ContainerType.T -> 'b

   end;
