use "collections/type.sig";

signature PointerType =
   sig
      structure BaseType: Type
      structure ContainerType: Type
      structure PointerType: Type

      val select: PointerType.T * ContainerType.T -> BaseType.T

   end;