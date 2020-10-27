use "pprint/base.sig";
use "test/assert.sig";
use "test/case.sig";

functor TestAssert(X:
   sig
      structure Base: PPrintBase
      structure Case: TestCase
         where type state_t =  Base.state_t
   end ): TestAssert =
   struct

      type testcase_t =  X.Case.testcase_t

      fun assert (description, b) =  {
            description = description
         ,  perform =  (
               fn () =>  (
                  if b
                  then
                     Option.NONE
                  else
                     Option.SOME (fn (_, _) => ()) ))}

   end
