use "collections/type.sig";
use "logics/pprint/pprintable.sig";
use "logics/pprint/pprinting.fun";

functor PPrintSetAlikes(X:
   sig
      structure Single: PPrintPPrintable
      structure Multi: Type
      val transition: (Single.T * 'b -> 'b Option.option) -> Multi.T -> 'b -> 'b
   end ) =
   struct
      structure SinglePPrinting =  PPrintPPrinting(X.Single)
      type ConfigType =  {
            delim: string }

      fun (single_line: ConfigType -> X.Multi.T -> string) ({ delim = delim }: ConfigType) (mt: X.Multi.T)
         =  X.transition
               (  fn (st: X.Single.T, str: string)
                     => let
                           val item =  X.Single.single_line st
                        in if str = ""
                           then
                              Option.SOME item
                           else
                              Option.SOME (str ^ delim ^ " " ^ item)
                        end )
               mt
               ""

      fun (multi_line: ConfigType -> TextIO.outstream * X.Multi.T * int -> X.Single.PPrintIndentBase.indent * X.Single.PPrintIndentBase.state -> X.Single.PPrintIndentBase.state)
         ({ delim = delim }: ConfigType)
         ((stream: TextIO.outstream), (mt: X.Multi.T), (rhs_indent: int))
         (indent, state)
         =  let
               val indent' =  X.Single.PPrintIndentBase.get_deeper_indent indent
               val (last_item: X.Single.T Option.option, state_after)
                  =  X.transition
                        (  fn (st: X.Single.T, (x, state'))
                              => case(x) of
                                 Option.NONE
                                    => Option.SOME ((Option.SOME st), state')
                              |  Option.SOME (t: X.Single.T)
                                    => let
                                          val state'' =  X.Single.PPrintIndentBase.navigate_to_pos (stream, 0) (indent', state')
                                          val state''' =  SinglePPrinting.pprint (stream, t, 0) (indent', state'')
                                          val state'''' =  X.Single.PPrintIndentBase.navigate_to_pos (stream, 0) (indent, state''')
                                          val state''''' =  X.Single.PPrintIndentBase.print_par (stream, delim) state''''
                                       in Option.SOME ((Option.SOME st), state''''')
                                       end )
                        mt
                        (Option.NONE, state)
               val state_after'
                  =  case(last_item) of
                     Option.NONE =>  state_after
                  |  Option.SOME (t: X.Single.T)
                     => X.Single.PPrintIndentBase.navigate_to_pos (stream, rhs_indent) (indent', state_after)
            in
               state_after'
            end
   end;
