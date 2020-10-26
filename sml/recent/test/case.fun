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

   end;
