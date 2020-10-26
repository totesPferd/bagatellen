use "pprint/base.sig";
use "pprint/construction_a.sig";

functor PPrintConstructionAByPar(X:
   sig
      val open_par: string
      val close_par: string
      structure Base: PPrintBase
      structure ConstructionA: PPrintConstructionA
         where type state_t =  Base.state_t
   end ): PPrintConstructionA =
   struct

      type context_t =  X.ConstructionA.context_t
      type state_t =  X.Base.state_t

      type T =  X.ConstructionA.T

      fun single_line(ctxt, t) =  X.open_par ^ X.ConstructionA.single_line(ctxt, t) ^ X.close_par
      fun multi_line(stream, ctxt, t) state =  (
            X.Base.print_open_par(stream, X.open_par) state
         ;  X.ConstructionA.multi_line(stream, ctxt, t) state
         ;  X.Base.print_close_par(stream, X.close_par) state )

   end
