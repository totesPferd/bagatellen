use "pprint/base.sig";
use "test/case.sig";

functor TestCase(X:
   sig
      structure Base: PPrintBase
   end ): TestCase =
   struct

      type state_t =  X.Base.state_t

      type testcase_t =  {
            description: string
         ,  perform: unit -> (TextIO.outstream * state_t -> unit) Option.option }
      type testsuite_t =  {
            description: string
         ,  perform: TextIO.outstream * state_t -> bool }

      fun name_testcase (name, testcase) =  {
            description =  (#description testcase)
         ,  perform =  (
               fn () =>  (
                  case ((#perform testcase)()) of
                        Option.NONE =>  Option.NONE
                     |  Option.SOME f =>  Option.SOME (
                           fn (stream, state) =>  (
                                 X.Base.print_tok(stream, name) state
                              ;  X.Base.print_nl stream state
                              ;  f (stream, state) ))))}

      local
         val init_f =  ((fn (_, _) => ()), true)
         fun app_f (testcase, (f, b)) =
            let
               val testresult =  (#perform testcase)()
            in
               case testresult of
                     Option.NONE =>  (
                           (  fn (stream, state) =>  (
                                 f (stream, state)
                              ;  X.Base.print_close_par(stream, "+") state
                              ;  X.Base.print_tok(stream, (#description testcase)) state
                              ;  X.Base.print_nl stream state ))
                        ,  b )
                  |  Option.SOME g =>  (
                           (  fn (stream, state) =>  (
                                 f (stream, state)
                              ;  X.Base.print_close_par(stream, "-") state
                              ;  X.Base.print_tok(stream, (#description testcase)) state
                              ;  X.Base.set_deeper_indent state
                              ;  X.Base.print_nl stream state
                              ;  g (stream, state)
                              ;  X.Base.restore_indent state
                              ;  X.Base.print_nl stream state ))
                         ,  false )
            end
      in
         fun collect_testcases (description, testcases_list) =  {
               description = description
            ,  perform =  (
                  fn () =>
                     let
                        val (f, b) =  List.foldl app_f init_f testcases_list
                     in
                        if b
                        then
                           Option.NONE
                        else
                           Option.SOME f
                     end )}
      end

   end;
