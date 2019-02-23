use "general/type.sig";

signature BaseMap =
   sig
      structure Start: Type
      structure End: Type
      structure Map: Type

      val apply: Map.T -> Start.T -> End.T
      val get_map: (Start.T -> End.T) -> Map.T

   end;
