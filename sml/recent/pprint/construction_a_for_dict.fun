use "general/dict_keys.sig";
use "pprint/able.sig";
use "pprint/base.sig";
use "pprint/construction_a.sig";

functor PPrintConstructionAForDict(X:
   sig
      structure Base: PPrintBase
      structure DictKeys: DictKeys
      structure ConstructionAForKeyValPair: PPrintConstructionA
         where type state_t =  Base.state_t
           and type T =  DictKeys.From.key_t * DictKeys.From.val_t
      structure AbleForKeyValPair: PPrintAble
         where type context_t =  ConstructionAForKeyValPair.context_t
           and type state_t =  Base.state_t
           and type T =  DictKeys.From.key_t * DictKeys.From.val_t
   end ): PPrintConstructionA =
   struct

      type context_t =  X.ConstructionAForKeyValPair.context_t
      type state_t =  X.Base.state_t

      type T =  X.DictKeys.From.T

      fun single_line (ctxt, t) =
         let
            val keys =  X.DictKeys.keys t
         in
            X.DictKeys.To.transition
               (  fn (k, str_l) =>
                     let
                        val v =  Option.valOf (X.DictKeys.From.deref (k, t))
                        val bstr =  X.ConstructionAForKeyValPair.single_line (ctxt, (k, v))
                        val str =  str_l()
                     in
                        if str = ""
                        then
                           bstr
                        else
                           (bstr ^ ", " ^ str_l())
                     end )
               keys
               ""
         end

      fun multi_line (stream, ctxt, t) state =
         let
            val keys =  X.DictKeys.keys t
         in (
               X.Base.set_deeper_indent state
            ;  X.Base.navigate_to_rel_pos(stream, 0) state
   
            ;  case (X.DictKeys.To.next keys) of
                  Option.NONE =>  ()
               |  Option.SOME (k, tl) =>
                     let
                        val v =  Option.valOf (X.DictKeys.From.deref (k, t))
                     in (
                           X.Base.set_deeper_indent state
                        ;  X.Base.navigate_to_rel_pos(stream, 0) state
                        ;  X.AbleForKeyValPair.pprint(stream, ctxt, (k, v)) state
                        ;  X.Base.restore_indent state
      
                        ;  (  X.DictKeys.To.transition
                                 (  fn (b, prev_state_l) =>  (
                                          X.Base.navigate_to_rel_pos(stream, 0) state
                                       ;  X.Base.print_close_par(stream, ",") state
                                       ;  X.Base.set_deeper_indent state
                                       ;  X.Base.navigate_to_rel_pos(stream, 0) state
                                       ;  X.AbleForKeyValPair.pprint(stream, ctxt, (k, v)) state
                                       ;  X.Base.restore_indent state
                                       ;  prev_state_l() ))
                                 tl
                                 () ))
                     end
   
            ;  X.Base.force_ws state
            ;  X.Base.restore_indent state )
         end

   end;
