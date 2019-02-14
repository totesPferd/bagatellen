use "logics/pprint/base.sig";

structure PPrintBase: PPrintBase =
   struct
      type state =  {
            col: int
         ,  is_need_ws: bool }

      val init =  { col = 1, is_need_ws = false }: state
      fun print_par (stream, str) (state: state)
         =  (  TextIO.output(stream, str)
            ;  {  col =  (#col state) + String.size(str), is_need_ws =  true }: state )
      fun print_nl stream state
         = (   TextIO.output(stream, "\n")
            ;  { col = 1, is_need_ws = false }: state )
      fun print_ws (stream,str) (state: state)
         = (   TextIO.output(stream, str)
            ;  { col =  (#col state) + String.size(str), is_need_ws =  false }: state )
      fun print (stream, str) (state: state)
         = (   TextIO.output(stream, str)
            ;  { col =  (#col state) + String.size(str), is_need_ws = true }: state )

      local
         fun ntp (stream, pos) (state: state)
            =  if (#col state) = pos
               then
                  state
               else
                  ntp (stream, pos) (print(stream, " ") state)
      in fun navigate_to_pos (stream, pos) (state: state)
            =  let
                  val real_col
                     =  if #is_need_ws state
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
