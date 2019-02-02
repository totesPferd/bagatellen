use "collections/type.sig";
use "collections/unit_type.sml";
use "logics/pointer_type.sig";
use "logics/variables.sig";

functor UnitPointerType(B: Variables): PointerType =
   struct
      structure BaseType =  B
      structure ContainerType =
         struct
            type T =  B.T Option.option
         end
      structure ItemType =  B
      structure PointerType =  UnitType

      exception NotFound
      fun select(sel, c)
        = case (c) of
             Option.NONE => raise NotFound
          |  Option.SOME b => b

   end;
