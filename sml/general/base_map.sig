use "general/type_map.sig";

signature BaseMap =
   sig
      include TypeMap

      val get_map: (Start.T -> End.T) -> Map.T

   end;
