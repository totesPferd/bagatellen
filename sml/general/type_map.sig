use "general/type.sig";

signature TypeMap =
   sig
      structure Start: Type
      structure End: Type
      structure Map: Type

      val apply: Map.T -> Start.T -> End.T

   end;
