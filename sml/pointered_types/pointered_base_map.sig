use "pointered_types/pointered_type_map.sig";

signature PointeredBaseMap =
   sig
      include PointeredTypeMap

      val get_map: (PointerType.T * Start.T -> End.T) -> Map.T

   end;

