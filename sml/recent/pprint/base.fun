use "general/string_utils.sig";
use "pprint/base.sig";
use "pprint/config.sig";

functor PPrintBase(X:
   sig
      structure StringUtils: StringUtils
      structure Config: PPrintConfig
   end ): PPrintBase =
   struct
      datatype ws_req =  no_need_of_ws | need_of_small_ws | need_of_big_ws | forced_need_of_ws;

      type state_t =  {
            col: int
         ,  is_need_ws: ws_req
         ,  indent: int
         ,  outstanding_txt: string option } ref

      val init =  ref { col = 1, is_need_ws = no_need_of_ws, indent = 0, outstanding_txt = NONE }
      fun set_deeper_indent state
         =  state :=  {
               col = (#col (!state))
            ,  is_need_ws = (#is_need_ws (!state))
            ,  indent = (#indent (!state)) + X.Config.indent
            ,  outstanding_txt = (#outstanding_txt (!state)) }
      fun restore_indent state
         =  state :=  {
               col = (#col (!state))
            ,  is_need_ws = (#is_need_ws (!state))
            ,  indent = (#indent (!state)) - X.Config.indent
            ,  outstanding_txt = (#outstanding_txt (!state)) }
      fun force_ws (state: state_t)
         =  state :=  {
               col = (#col (!state))
            ,  is_need_ws = forced_need_of_ws
            ,  indent = (#indent (!state))
            ,  outstanding_txt = (#outstanding_txt (!state)) }
      fun print_nl stream state
         =
            (   TextIO.output(stream, "\n")
             ;  state :=  {
                   col = (#indent (!state))
                ,  is_need_ws = no_need_of_ws
                ,  indent = (#indent (!state))
                ,  outstanding_txt = SOME (X.StringUtils.rep (" ", (#indent (!state)))) })
      fun print_ws (stream, str) state
         = let
            val outstanding_txt =  case (#outstanding_txt (!state)) of
                  NONE       => str
               |  SOME other => other ^ str
           in state :=  {
                    col = (#col (!state)) + String.size(str)
                 ,  is_need_ws =  no_need_of_ws
                 ,  indent = (#indent (!state))
                 ,  outstanding_txt = SOME outstanding_txt }
           end
      local
         fun print_directly (stream, str, ws_req) state
            = (
                  case (#outstanding_txt (!state)) of
                        NONE      =>  ()
                     |  SOME ostr =>  TextIO.output(stream, ostr)
               ;  TextIO.output(stream, str)
               ;  state :=  {
                        col = (#col (!state)) + String.size(str)
                     ,  is_need_ws =  ws_req
                     ,  indent = (#indent (!state))
                     ,  outstanding_txt = NONE })
         fun print_big_and_small_ws stream state
            =  let
                  val ws =  if (#is_need_ws (!state)) = need_of_big_ws
                  then
                     "  "
                  else
                     " "
               in print_ws (stream, ws) state
               end
         fun check_line_exceed (stream, str) state
            =  if (#col (!state)) + String.size(str) > X.Config.page_width
               then
                  print_nl stream state
               else
                  ()
         fun print_par_with_big_and_small_ws ws_req (stream, str) state
            =  (
                     check_line_exceed (stream, str) state
                  ;  if (#is_need_ws (!state)) = forced_need_of_ws
                     then
                        print_big_and_small_ws stream state
                     else
                        ()
                  ;  print_directly (stream, str, ws_req) state )
         fun print_tok_with_big_and_small_ws ws_req (stream, str) state
            =  (
                     check_line_exceed (stream, str) state
                  ;  if (#is_need_ws (!state)) <> no_need_of_ws
                     then
                        print_big_and_small_ws stream state
                     else
                        ()
                  ;  print_directly (stream, str, ws_req) state )
      in
         val print_open_par =  print_par_with_big_and_small_ws no_need_of_ws
         val print_close_par =  print_par_with_big_and_small_ws need_of_small_ws
         val print_period =  print_par_with_big_and_small_ws need_of_big_ws
         val print_tok =  print_tok_with_big_and_small_ws need_of_small_ws
         val print_assign =  print_tok_with_big_and_small_ws need_of_big_ws
      end
      fun navigate_to_pos (stream, pos) state
         =  while (#col (!state)) <> pos
            do (
                  if (#col (!state)) > pos
                  then
                     print_nl stream state
                  else
                     print_ws (stream, " ") state )
      fun navigate_to_rel_pos (stream, pos) state
         =  navigate_to_pos (stream, pos + (#indent (!state))) state
      fun get_remaining_line_width_after_indent state =  X.Config.page_width - (#indent (!state))
      fun get_remaining_line_width state =  X.Config.page_width - (#col (!state))

   end;
