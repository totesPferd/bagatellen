use "general/map.sig";

signature BaseMapExtension =
   sig
      structure BaseMap: Map

      val get_map: (BaseMap.Start.T -> BaseMap.End.T) -> BaseMap.T

   end;
