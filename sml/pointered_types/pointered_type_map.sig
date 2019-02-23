use "general/type.sig";

signature PointeredTypeMap =
   sig
      structure Start: Type
      structure End: Type
      structure Map: Type
      structure PointerType: Type

      val apply: Map.T -> PointerType.T * Start.T -> End.T

   end;
