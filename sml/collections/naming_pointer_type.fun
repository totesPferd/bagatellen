use "collections/pointer_type.sig";
use "collections/string_type.sml";

functor NamingPointerType(B: Type): PointerType =
   struct
      structure BaseType =  B
      structure ContainerType =
         struct
            type T =  (string Option.option ref * B.T) list
         end
      structure PointerType =  StringType

      exception NotFound
      fun select(sel: PointerType.T, c: ContainerType.T)
        = let
             fun is_found(s, b)
               = case(!s) of
                    Option.NONE =>  false
                 |  Option.SOME x => (sel = x)
             val found =  List.find is_found c
          in
             case (found) of
                Option.NONE =>  raise NotFound
             |  Option.SOME (_, b) =>  b
          end
   end;
