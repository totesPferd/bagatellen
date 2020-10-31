use "general/dict_map.sig";
use "pprint/base.sig";
use "test/assert.sig";
use "test/assert_eq.sig";
use "test/case.sig";
use "test/suite.sig";

functor DictMapSuite(X:
   sig
      structure Base: PPrintBase
      structure DictMap: DictMap
         where type From.key_t = string
           and type From.val_t = string
           and type To.key_t = string
           and type To.val_t = string
      structure Case: TestCase
         where type state_t =  Base.state_t
      structure Assert: TestAssert
         where type testcase_t =  Case.testcase_t
      structure AssertEqForString: TestAssertEq
         where type context_t =  unit
           and type testcase_t =  Case.testcase_t
           and type T =  string
      structure AssertEqForStringStringDict: TestAssertEq
         where type context_t =  unit
           and type testcase_t =  Case.testcase_t
           and type T =  DictMap.To.T
   end ): TestSuite =
   struct
      open X.Case

      type context_t =  unit

      val suite =  collect_testcases (
            "dict_map"
         ,  [
                  ])
   end;
