use "logics/pprint/base.sig";

structure PPrintBase: PPrintBase =
   struct
      datatype ws_req =  no_need_of_ws | need_of_ws | forced_need_of_ws;

      type state =  {
            col: int
         ,  is_need_ws: ws_req }

      val init =  { col = 1, is_need_ws = no_need_of_ws }: state
      fun force_ws (state: state)
         =  {  col = (#col state), is_need_ws = forced_need_of_ws }
      fun print_par (stream, str) (state: state)
         =  let
               val real_col
                  =  if (#is_need_ws state) = forced_need_of_ws
                     then (
                           TextIO.output(stream, " ")
                        ;  (#col state) + 1 )
                     else
                        (#col state)
            in (
                  TextIO.output(stream, str)
               ;  {  col = real_col + String.size(str), is_need_ws =  need_of_ws }: state )
            end
      fun print_nl stream state
         = (   TextIO.output(stream, "\n")
            ;  { col = 1, is_need_ws = no_need_of_ws }: state )
      fun print_ws (stream,str) (state: state)
         = (   TextIO.output(stream, str)
            ;  { col = (#col state) + String.size(str), is_need_ws =  no_need_of_ws }: state )
      fun print (stream, str) (state: state)
         =  let
               val real_col
                  =  if (#is_need_ws state) = need_of_ws
                     then (
                           TextIO.output(stream, " ")
                        ;  (#col state) + 1)
                     else
                        (#col state)
            in (  TextIO.output(stream, str)
               ;  { col = real_col + String.size(str), is_need_ws = need_of_ws }: state )
            end
      local
         fun ntp (stream, pos) (state: state)
            =  if (#col state) = pos
               then
                  state
               else
                  ntp (stream, pos) (print_ws(stream, " ") state)
      in fun navigate_to_pos (stream, pos) (state: state)
            =  let
                  val real_col
                     =  if (#is_need_ws state) = need_of_ws
                        then
                           (#col state) + 1
                        else
                           (#col state)
                  val state'
                     =  if real_col > pos
                        then
                           print_nl stream state
                        else
                           state
               in
                  ntp (stream, pos) state'
               end
      end
      
   end;
