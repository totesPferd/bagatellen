use "logics/pprint/base.sig";

structure PPrintBase: PPrintBase =
   struct
      type state =  {
            col: int }

      val init =  { col = 1 }: state
      fun print_nl stream state
         = (
               TextIO.output(stream, "\n")
            ;  { col = 1 }: state )
      fun print (stream, str) (state: state)
         = (
               TextIO.output(stream, str)
            ;  { col =  (#col state) + String.size(str) }: state )

      local
         fun ntp (stream, pos) (state: state)
            =  if (#col state) = pos
               then
                  state
               else
                  ntp (stream, pos) (print(stream, " ") state)
      in fun navigate_to_pos (stream, pos, is_need_ws) (state: state)
            =  let
                  val real_col
                     =  if is_need_ws
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
