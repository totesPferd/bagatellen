use "general/eqs.sig";

signature PointeredTypeGenerating =
   sig
      structure PolymorphicContainerType:
         sig
            type 'a T
         end
      structure PointeredType:
         sig
            structure BaseType: Eqs
            structure ContainerType:
            sig
               type T =  BaseType.T PolymorphicContainerType.T
               val eq: T * T -> bool
            end
         structure PointerType: Type

         val empty: ContainerType.T
         val is_empty: ContainerType.T -> bool
         val select: PointerType.T * ContainerType.T -> BaseType.T Option.option
      end

   end;

