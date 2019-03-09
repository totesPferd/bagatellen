use "general/type.sig";

signature PointeredType =
   sig
      structure BaseType: Type
      structure ContainerType: Type
      structure PointerType: Type

      structure BaseStructure:
         sig
         end

      val empty:     ContainerType.T
      val is_empty:  ContainerType.T -> bool
      val select:    PointerType.T * ContainerType.T -> BaseType.T Option.option

   end;
