use "pprint/able.sig";
use "pprint/base.sig";

functor PPrintAbleByPar(X:
   sig
      val open_par: string
      val close_par: string
      structure Base: PPrintBase
      structure Able: PPrintAble
         where type state_t =  Base.state_t
   end ): PPrintAble =
   struct

      type context_t =  X.Able.context_t
      type state_t =  X.Base.state_t

      type T =  X.Able.T

      fun pprint(stream, ctxt, t) state =  (
            X.Base.print_open_par(stream, X.open_par) state
         ;  X.Able.pprint(stream,ctxt, t) state
         ;  X.Base.print_close_par(stream, X.close_par) state )

   end;
