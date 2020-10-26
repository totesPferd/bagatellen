use "test/result.sig";

exception CannotExplainPassedTest;

functor TestResult(X:
   sig
      type state_t
   end ): TestResult =
   struct

      open X

      type testresult_t =  (TextIO.outstream * X.state_t -> unit) option

      val is_passed =  not o Option.isSome
      fun explain (stream, result) state =
         case(result) of
               Option.NONE =>  raise CannotExplainPassedTest
            |  Option.SOME f => f(stream, state)

   end;
