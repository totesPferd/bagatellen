signature Acc =
   sig
      val transition: ('a * 'b -> 'b Option.option) -> 'a list -> 'b -> 'b
   end;
