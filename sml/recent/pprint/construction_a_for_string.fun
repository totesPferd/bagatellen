use "pprint/base.sig";
use "pprint/construction_a.sig";

functor PPrintConstructionAForString(X:
   sig

      type context_t

      structure Base: PPrintBase

   end): PPrintConstructionA =
   struct

      type context_t =  X.context_t
      type state_t =  X.Base.state_t

      type T =  string

      fun single_line (_, t) =  t

      fun multi_line (stream, _, t) state =
         X.Base.print_tok(stream, t) state

   end;
