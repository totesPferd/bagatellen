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
             fun prec_state_l () =  transition phi tl b
          in phi(hd, prec_state_l)
          end
   end;
