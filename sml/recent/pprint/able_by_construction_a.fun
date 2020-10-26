use "pprint/able.sig";
use "pprint/base.sig";
use "pprint/construction_a.sig";

functor PPrintAbleByConstructionA (X:
   sig
      val opening_par: string
      val closing_par: string
      structure Base: PPrintBase
      structure ConstructionA: PPrintConstructionA
         where type state_t = Base.state_t
   end ): PPrintAble =
   struct

      type state_t =  X.Base.state_t
      type context_t =  X.ConstructionA.context_t

      type T =  X.ConstructionA.T

      fun pprint(stream, ctxt, data) state =
         let
            val check_single_line =  X.ConstructionA.single_line (ctxt, data)
         in (
               X.Base.print_open_par(stream, X.opening_par) state
   
            ;  if String.size(check_single_line) >= X.Base.get_remaining_line_width state
               then
                  X.ConstructionA.multi_line(stream, ctxt, data) state
               else
                  X.Base.print_tok(stream, check_single_line) state

            ;  X.Base.print_close_par(stream, X.closing_par) state )
         end
   end;
