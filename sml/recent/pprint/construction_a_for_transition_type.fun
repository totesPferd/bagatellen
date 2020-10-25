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
            (  fn (b, str_l) =>
                  let
                     val bstr =  X.ConstructionA.single_line (ctxt, b)
                     val str =  str_l()
                  in
                     if str = ""
                     then
                        bstr
                     else
                        (bstr ^ X.delim ^ " " ^ str_l())
                  end )
            t
            ""

      fun multi_line (stream, ctxt, t) state =  (
            X.Base.set_deeper_indent state
         ;  X.Base.navigate_to_rel_pos(stream, 0) state

         ;  X.TransitionType.transition
               (  fn (b, is_last_item_l) =>  (
                        if is_last_item_l()
                        then
                           ()
                        else
                           X.Base.print_close_par(stream, X.delim) state
                     ;  X.Base.set_deeper_indent state
                     ;  X.Base.navigate_to_rel_pos(stream, 0) state
                     ;  X.Able.pprint(stream, ctxt, b) state
                     ;  X.Base.restore_indent state
                     ;  false ))
               t
               true

         ;  X.Base.force_ws state
         ;  X.Base.restore_indent state )

   end ;
