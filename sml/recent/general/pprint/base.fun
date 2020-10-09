use "general/pprint/base.sig";
use "general/pprint/config.sig";

functor PPrintBase(X: PPrintConfig): PPrintBase =
   struct
      datatype ws_req =  no_need_of_ws | need_of_ws | forced_need_of_ws;

      type state =  {
            col: int
         ,  is_need_ws: ws_req }

      val init =  { col = 1, is_need_ws = no_need_of_ws }: state
      fun force_ws (state: state)
         =  {  col = (#col state), is_need_ws = forced_need_of_ws }
      fun print_nl stream state
         = (   TextIO.output(stream, "\n")
            ;  { col = 1, is_need_ws = no_need_of_ws }: state )
      fun print_directly (stream, str, ws_req) (state: state)
         = (
               TextIO.output(stream, str)
            ;  { col = (#col state) + String.size(str), is_need_ws =  ws_req }: state )
      fun print_ws (stream, str) (state: state)
         =  print_directly (stream, str, no_need_of_ws) (state: state)
      fun print_par (stream, str) (state: state)
         =  let
               val state'
                  =  if (#col state) + String.size(str) > (#page_width X.config)
                     then
                        print_nl stream state
                     else
                        state
               val state''
                  =  if (#is_need_ws state') = forced_need_of_ws
                     then
                        print_ws (stream, " ") state
                     else
                        state'
            in print_directly (stream, str, no_need_of_ws) state''
            end
      fun print (stream, str) (state: state)
         =  let
               val state'
                  =  if (#col state) + String.size(str) > (#page_width X.config)
                     then
                        print_nl stream state
                     else
                        state
               val state''
                  =  if not ((#is_need_ws state') = no_need_of_ws)
                     then
                        print_ws (stream, " ") state
                     else
                        state'
            in print_directly (stream, str, need_of_ws) state''
            end
      local
         fun ntp (stream, pos) (state: state)
            =  if (#col state) >= pos
               then
                  state
               else
                  ntp (stream, pos) (print_ws(stream, " ") state)
      in fun navigate_to_pos (stream, pos) (state: state)
            =  let
                  val state'
                     =  if (#col state) > pos
                        then
                           print_nl stream state
                        else
                           state
               in
                  ntp (stream, pos) state'
               end
      end

   end;
