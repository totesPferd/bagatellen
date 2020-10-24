use "general/transition_type.sig";
use "pprint/able.sig";
use "pprint/base.sig";
use "pprint/construction_a.sig";

functor PPrintConstructionAForTransitionType (X:
   sig
      val delim: string
      structure Able: PPrintAble
      structure Base: PPrintBase
         where type state_t =  Able.state_t
      structure ConstructionA: PPrintConstructionA
         where type context_t =  Able.context_t
           and type state_t = Able.state_t
           and type T = Able.T
      structure TransitionType: TransitionType
         where type base_t =  Able.T
   end ): PPrintConstructionA =
   struct

      type context_t =  X.Able.context_t
      type state_t =  X.Able.state_t

      type T =  X.TransitionType.T

      fun single_line (ctxt, t) =
         X.TransitionType.transition
            (  fn (b, str) =>
                  let
                     val bstr =  X.ConstructionA.single_line (ctxt, b)
                  in
                     if str = ""
                     then
                        Option.SOME bstr
                     else
                        Option.SOME (str ^ X.delim ^ " " ^ bstr)
                  end )
            t
            ""

      fun multi_line (stream, ctxt, t) state =  (
            X.Base.set_deeper_indent state

         ;  X.TransitionType.transition
               (  fn (b, is_last_item) =>  (
                        X.Base.set_deeper_indent state
                     ;  X.Able.pprint(stream, ctxt, b)
                     ;  X.Base.restore_indent state
                     ;  if is_last_item
                        then
                           X.Base.force_ws state
                        else
                           X.Base.print_close_par(stream, X.delim) state
                     ;  Option.SOME false ))
               t
               true

         ;  X.Base.restore_indent state )

   end ;
