use "general/transition_type.sig";

functor TransitionTypeByList (X:
   sig
      type base_t
   end ): TransitionType =
   struct
      open X

      type T =  base_t list

      fun transition phi nil b =  b
        | transition phi (hd :: tl) b
        = let
             val prec_state =  transition phi tl b
          in case(phi(hd, prec_state)) of
                Option.NONE => prec_state
             |  Option.SOME r => r
          end
   end;
