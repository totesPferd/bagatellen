use "collections/pointer_type.sig";
use "collections/type.sig";
use "collections/unit_type.sml";

functor UnitPointerType(B: Type): PointerType =
   struct
      structure BaseType =  B
      structure ContainerType =
         struct
            type T =  B.T Option.option
         end
      structure PointerType =  UnitType

      exception NotFound
      fun select(sel, c)
        = case (c) of
             Option.NONE => raise NotFound
          |  Option.SOME b => b

      fun fold f b Option.NONE =  b
        | fold f b (Option.SOME x) =  f(x, b)
   end;
