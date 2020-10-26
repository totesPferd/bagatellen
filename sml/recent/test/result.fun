use "pprint/base.sig";
use "test/result.sig";

exception CannotExplainPassedTest;

functor TestResult(X:
   sig
      structure Base: PPrintBase
   end ): TestResult =
   struct

      type state_t =  X.Base.state_t

      type testresult_t =  (TextIO.outstream * state_t -> unit) option

      val is_passed =  not o Option.isSome
      fun explain (stream, result) state =
         case(result) of
               Option.NONE =>  raise CannotExplainPassedTest
            |  Option.SOME f => (
               X.Base.set_deeper_indent state
            ;  f(stream, state)
            ;  X.Base.print_nl stream state
            ;  X.Base.restore_indent state )

      fun name_testresult _ Option.NONE =  Option.NONE
        | name_testresult name (Option.SOME f) =  Option.SOME (
            (   fn (stream, state) =>  (
                   X.Base.print_tok(stream, name) state
                ;  X.Base.print_nl stream state
                ;  f(stream, state) )))

   end;
