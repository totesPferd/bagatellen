use "collections/type.sig";

signature NamingPointerType =
   sig
     structure BaseType: Type
     structure ContainerType: Type

     val new : ContainerType.T
     val get_name : BaseType.T
                    -> ContainerType.T -> string option
     val set_name : string * BaseType.T
                    -> ContainerType.T -> bool
     val uniquize : ContainerType.T -> unit
   end;

