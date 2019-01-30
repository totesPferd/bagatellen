use "collections/acc.sig";

structure Acc: Acc =
   struct
      fun transition phi nil b =  b
        | transition phi (hd :: tl) b
        = let
             val prec_state =  transition phi tl b
          in case(phi(hd, prec_state)) of
                Option.NONE => prec_state
             |  Option.SOME r => r
          end
   end;
