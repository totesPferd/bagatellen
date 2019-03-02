use "general/eqs.sig";
use "collections/naming_polymorphic_container_type.sig";

signature NamingPointeredTypeGenerating =
   sig
      structure PolymorphicContainerType: NamingPolymorphicContainerType

      structure PointeredType:
         sig
            structure BaseType: Eqs
            structure ContainerType:
               sig
                  type T =  BaseType.T PolymorphicContainerType.T
               end
            structure PointerType:
               sig
                  type T =  string Option.option ref
               end
      
            val empty: ContainerType.T
            val is_empty: ContainerType.T -> bool
            val select: PointerType.T * ContainerType.T -> BaseType.T Option.option

            val all:        (BaseType.T -> bool) -> ContainerType.T -> bool
            val all_zip:    (BaseType.T * BaseType.T -> bool) -> (ContainerType.T * ContainerType.T) -> bool
      
            val fe:         BaseType.T -> ContainerType.T
            val fop:        (BaseType.T -> ContainerType.T) -> ContainerType.T -> ContainerType.T
            val is_in:      BaseType.T * ContainerType.T -> bool
            val subeq:      ContainerType.T * ContainerType.T -> bool
      
            val map:        (BaseType.T -> BaseType.T) -> ContainerType.T -> ContainerType.T
            val filter:     (BaseType.T -> bool) -> ContainerType.T -> ContainerType.T
            val transition: (BaseType.T * 'b -> 'b Option.option) -> ContainerType.T -> 'b -> 'b

      end
 
      val singleton: PointeredType.PointerType.T * PointeredType.BaseType.T -> PointeredType.ContainerType.T

      val sum:        PointeredType.ContainerType.T * PointeredType.ContainerType.T -> PointeredType.ContainerType.T
 
      val add:        PointeredType.BaseType.T -> PointeredType.ContainerType.T -> PointeredType.ContainerType.T
      val adjoin:     string * PointeredType.BaseType.T * PointeredType.ContainerType.T -> PointeredType.ContainerType.T
      val transition: (string Option.option * PointeredType.BaseType.T * 'b -> 'b Option.option) -> PointeredType.ContainerType.T -> 'b -> 'b
 
      val get_name :  PointeredType.BaseType.T
                      -> PointeredType.ContainerType.T -> string option
      val set_name :  string * PointeredType.BaseType.T
                      -> PointeredType.ContainerType.T -> bool
      val uniquize :  PointeredType.ContainerType.T -> unit

   end;

