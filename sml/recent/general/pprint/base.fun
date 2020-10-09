use "general/pprint/base.sig";
use "general/pprint/config.sig";

functor PPrintBase(X: PPrintConfig): PPrintBase =
   struct
      datatype ws_req =  no_need_of_ws | need_of_ws of bool | forced_need_of_ws;

      type state =  {
            col: int
         ,  is_need_ws: ws_req
         ,  outstanding_txt: string option }

      val init =  { col = 1, is_need_ws = no_need_of_ws, outstanding_txt = NONE }: state
      fun force_ws (state: state)
         =  {  col = (#col state), is_need_ws = forced_need_of_ws, outstanding_txt = (#outstanding_txt state) }
      fun print_nl stream state
         = (   TextIO.output(stream, "\n")
            ;  { col = 1, is_need_ws = no_need_of_ws, outstanding_txt = NONE }: state )
      fun print_ws (stream, str) (state: state)
         = let
            val outstanding_txt =  case (#outstanding_txt state) of
                  NONE       => str
               |  SOME other => other ^ str
           in { col = (#col state) + String.size(str), is_need_ws =  no_need_of_ws, outstanding_txt = SOME outstanding_txt }: state
           end
      local
         fun print_directly (stream, str, is_big_ws) (state: state)
            = (
                  case (#outstanding_txt state) of
                        NONE      =>  ()
                     |  SOME ostr =>  TextIO.output(stream, ostr)
               ;  TextIO.output(stream, str)
               ;  { col = (#col state) + String.size(str), is_need_ws =  need_of_ws is_big_ws, outstanding_txt = NONE }: state )
         fun print_big_and_small_ws stream state
            =  let
                  val ws =  if (#is_need_ws state) = need_of_ws true
                  then
                     "  "
                  else
                     " "
               in print_ws (stream, ws) state
               end
         fun check_line_exceed (stream, str) state
            =  if (#col state) + String.size(str) > (#page_width X.config)
               then
                  print_nl stream state
               else
                  state
         fun print_par_with_big_and_small_ws is_big (stream, str) (state: state)
            =  let
                  val state' =  check_line_exceed (stream, str) state
                  val state''
                     =  if (#is_need_ws state') = forced_need_of_ws
                        then
                           print_big_and_small_ws stream state'
                        else
                           state'
               in print_directly (stream, str, is_big) state''
               end
         fun print_tok_with_big_and_small_ws is_big (stream, str) (state: state)
            =  let
                  val state' =  check_line_exceed (stream, str) state
                  val state''
                     =  if not ((#is_need_ws state') = no_need_of_ws)
                        then
                           print_big_and_small_ws stream state'
                        else
                           state'
               in print_directly (stream, str, is_big) state''
               end
      in
         val print_par =  print_par_with_big_and_small_ws false
         val print_period =  print_par_with_big_and_small_ws true
         val print_tok =  print_tok_with_big_and_small_ws false
         val print_assign =  print_tok_with_big_and_small_ws true
      end
      fun navigate_to_pos (stream, pos) (state: state)
         = let
            val state_ptr =  ref state
           in (
                 while (#col (!state_ptr)) <> pos
                 do state_ptr := (
                       if (#col (!state_ptr)) > pos
                       then
                          print_nl stream (!state_ptr)
                       else
                          print_ws(stream, " ") (!state_ptr) )
              ;  !state_ptr )
           end

   end;
