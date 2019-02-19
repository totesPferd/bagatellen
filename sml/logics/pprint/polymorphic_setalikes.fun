use "general/type.sig";
use "logics/pprint/delim_config.sig";
use "logics/pprint/pprintable.sig";
use "logics/pprint/polymorphic_setalikes.sig";

functor PPrintSetalikes(X:
   sig
      structure ContextType: Type
      structure DelimConfig: PPrintDelimConfig
      structure PPrintIndentBase: PPrintIndentBase
   end ): PPrintPolymorphicSetalikes =
   struct
      structure PPrintDelimConfig =  X.DelimConfig
      structure ContextType =  X.ContextType
      structure PPrintIndentBase =  X.PPrintIndentBase

      fun single_line transition (s_single_line) ctxt mt
         =  transition
               (  fn (st, str: string)
                     => let
                           val item =  s_single_line ctxt st
                        in if str = ""
                           then
                              Option.SOME item
                           else
                              Option.SOME (str ^ X.DelimConfig.delim ^ " " ^ item)
                        end )
               mt
               ""

      fun multi_line
         transition
         s_pprint
         ctxt
         ((stream: TextIO.outstream), mt, (rhs_indent: int))
         (indent, state)
         =  let
               val indent' =  PPrintIndentBase.get_deeper_indent indent
               val (last_item, state_after)
                  =  transition
                        (  fn (st, (x, state'))
                              => case(x) of
                                 Option.NONE
                                    => Option.SOME ((Option.SOME st), state')
                              |  Option.SOME t
                                    => let
                                          val state'' =  PPrintIndentBase.navigate_to_pos (stream, 0) (indent', state')
                                          val state''' =  s_pprint ctxt (stream, t, 0) (indent', state'')
                                          val state'''' =  PPrintIndentBase.navigate_to_pos (stream, 0) (indent, state''')
                                          val state''''' =  PPrintIndentBase.print_par (stream, X.DelimConfig.delim) state''''
                                       in Option.SOME ((Option.SOME st), state''''')
                                       end )
                        mt
                        (Option.NONE, state)
               val state_after'
                  =  case(last_item) of
                     Option.NONE =>  state_after
                  |  Option.SOME t
                     => let
                           val state_after'' =  PPrintIndentBase.navigate_to_pos (stream, rhs_indent) (indent', state_after)
                           val state_after''' =  s_pprint ctxt (stream, t, rhs_indent) (indent', state_after'')
                        in
                           state_after'''
                        end
            in
               state_after'
            end
   end;
