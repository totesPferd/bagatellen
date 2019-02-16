use "collections/type.sig";
use "logics/pprint/delim_config.sig";
use "logics/pprint/pprintable.sig";
use "logics/pprint/pprinting.fun";

functor PPrintSetAlikes(X:
   sig
      structure X:
         sig
            structure Single: PPrintPPrintable
            structure Multi: Type
            val transition: (Single.T * 'b -> 'b Option.option) -> Multi.T -> 'b -> 'b
         end
      structure DelimConfig: PPrintDelimConfig
   end ): PPrintPPrintable =
   struct
      structure SinglePPrinting =  PPrintPPrinting(X.X.Single)

      structure PPrintIndentBase =  X.X.Single.PPrintIndentBase
      type T =  X.X.Multi.T

      fun (single_line: T -> string) (mt: T)
         =  X.X.transition
               (  fn (st: X.X.Single.T, str: string)
                     => let
                           val item =  X.X.Single.single_line st
                        in if str = ""
                           then
                              Option.SOME item
                           else
                              Option.SOME (str ^ (#delim X.DelimConfig.config) ^ " " ^ item)
                        end )
               mt
               ""

      fun (multi_line: TextIO.outstream * T * int -> PPrintIndentBase.indent * PPrintIndentBase.state -> PPrintIndentBase.state)
         ((stream: TextIO.outstream), (mt: X.X.Multi.T), (rhs_indent: int))
         (indent, state)
         =  let
               val indent' =  X.X.Single.PPrintIndentBase.get_deeper_indent indent
               val (last_item: X.X.Single.T Option.option, state_after)
                  =  X.X.transition
                        (  fn (st: X.X.Single.T, (x, state'))
                              => case(x) of
                                 Option.NONE
                                    => Option.SOME ((Option.SOME st), state')
                              |  Option.SOME (t: X.X.Single.T)
                                    => let
                                          val state'' =  PPrintIndentBase.navigate_to_pos (stream, 0) (indent', state')
                                          val state''' =  SinglePPrinting.pprint (stream, t, 0) (indent', state'')
                                          val state'''' =  PPrintIndentBase.navigate_to_pos (stream, 0) (indent, state''')
                                          val state''''' =  PPrintIndentBase.print_par (stream, (#delim X.DelimConfig.config)) state''''
                                       in Option.SOME ((Option.SOME st), state''''')
                                       end )
                        mt
                        (Option.NONE, state)
               val state_after'
                  =  case(last_item) of
                     Option.NONE =>  state_after
                  |  Option.SOME (t: X.X.Single.T)
                     => PPrintIndentBase.navigate_to_pos (stream, rhs_indent) (indent', state_after)
            in
               state_after'
            end
   end;