use "collections/type.sig";
use "logics/variables.sig";

signature PointerType =
   sig
      structure BaseType: Type
      structure ContainerType: Type
      structure ItemType: Variables
      structure PointerType: Type

      val select: PointerType.T * ContainerType.T -> BaseType.T

   end;
