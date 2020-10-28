use "pprint/able.sig";
use "pprint/base.sig";
use "pprint/construction_a.sig";

functor PPrintConstructionAForKeyValPair(X:
   sig
      structure Base: PPrintBase
      structure KeyAble: PPrintAble
         where type state_t =  Base.state_t
      structure KeyConstructionA: PPrintConstructionA
         where type context_t =  KeyAble.context_t
           and type state_t = Base.state_t
           and type T = KeyAble.T
      structure ValAble: PPrintAble
         where type context_t =  KeyAble.context_t
           and type state_t =  Base.state_t
      structure ValConstructionA: PPrintConstructionA
         where type context_t =  KeyAble.context_t
           and type state_t = Base.state_t
           and type T = ValAble.T
   end ): PPrintConstructionA =
   struct

      type context_t =  X.KeyAble.context_t
      type state_t =  X.Base.state_t

      type T =  X.KeyAble.T * X.ValAble.T

      fun single_line (ctxt, (k, v)) =
            X.KeyConstructionA.single_line(ctxt, k)
         ^  ": "
         ^  X.ValConstructionA.single_line(ctxt, v)

      fun multi_line (stream, ctxt, (k, v)) state =  (
            X.KeyAble.pprint(stream, ctxt, k) state
         ;  X.Base.print_close_par(stream, ":") state
         ;  X.ValAble.pprint(stream, ctxt, v) state )

   end;

