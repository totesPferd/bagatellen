use "general/contected_eq_type.sig";
use "pprint/able.sig";
use "pprint/base.sig";
use "test/assert_eq.sig";
use "test/case.sig";

functor TestAssertEq(X:
   sig
      structure Base: PPrintBase
      structure Able: PPrintAble 
         where type state_t = Base.state_t
      structure CEq: ContectedEqType
         where type context_t =  Able.context_t
           and type T =  Able.T
      structure Case: TestCase
         where type state_t =  Base.state_t
   end ): TestAssertEq =
   struct

      type context_t =  X.CEq.context_t
      type testcase_t =  X.Case.testcase_t

      type T =  X.CEq.T

      fun assert(description, ctxt, x, y) =  {
            description = description
         ,  perform =  (
               (  fn () =>
                     if X.CEq.ceq(ctxt, x, y)
                     then
                        Option.NONE
                     else
                        Option.SOME (
                           fn (stream, state) =>  (
                                 X.Base.print_tok(stream, "Expected:") state
                             ;   X.Able.pprint(stream, ctxt, x) state
                             ;   X.Base.print_nl stream state
                             ;   X.Base.print_tok(stream, "Actually:") state
                             ;   X.Able.pprint(stream, ctxt, y) state
                             ;   X.Base.print_nl stream state ))))}

   end;
