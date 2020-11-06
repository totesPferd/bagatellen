use "general/item.sig";

structure Item: Item =
   struct
      type T =  unit ref

      fun new() =  ref()

   end;
