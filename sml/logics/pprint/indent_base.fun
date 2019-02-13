use "logics/pprint/base.sig";
use "logics/pprint/config.sig";
use "logics/pprint/indent_base.sig";

functor PPrintIndentBase(X:
   sig
      structure B: PPrintBase
      structure C: PPrintConfig
   end ): PPrintIndentBase =
   struct
      type indent =  { indent: int }
      type state =  X.B.state

      val init =  ( { indent = 0 }: indent, X.B.init )
      fun get_deeper_indent ({ indent = indent }: indent)
         =  { indent = indent + (#indent X.C.config) }: indent
      val print_nl =  X.B.print_nl
      val print =  X.B.print
      fun navigate_to_pos (stream, pos) (indent, state)
         =  let
               val abs_pos =  (#indent indent) + pos
            in
               X.B.navigate_to_pos (stream, abs_pos) state
            end
   end;
