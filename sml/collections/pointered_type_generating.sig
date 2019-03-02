use "general/type.sig";

signature PointeredTypeGenerating =
   sig
      structure PolymorphicContainerType:
         sig
            type 'a T
         end
      structure BaseType: Type
      structure ContainerType:
         sig
            type T =  BaseType.T PolymorphicContainerType.T
         end
      structure PointerType: Type

      val empty: ContainerType.T
      val is_empty: ContainerType.T -> bool
      val select: PointerType.T * ContainerType.T -> BaseType.T Option.option

   end;

