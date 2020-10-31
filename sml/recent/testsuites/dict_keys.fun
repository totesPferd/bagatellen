use "general/dict_keys.sig";
use "pkg/dict.sml";
use "pkg/string.sml";
use "pprint/base.sig";
use "test/assert.sig";
use "test/assert_eq.sig";
use "test/case.sig";
use "test/suite.sig";

functor DictKeysSuite(X:
   sig
      structure Base: PPrintBase
      structure DictKeys: DictKeys
         where type From.key_t = string
         where type From.val_t = string
      structure Set: Set
         where type base_t = string
      structure Case: TestCase
         where type state_t =  Base.state_t
      structure Assert: TestAssert
         where type testcase_t =  Case.testcase_t
      structure AssertEqForString: TestAssertEq
         where type context_t =  unit
           and type testcase_t =  Case.testcase_t
           and type T =  string
      structure AssertEqForStringSet: TestAssertEq
         where type context_t =  unit
           and type testcase_t =  Case.testcase_t
           and type T =  Set.T
   end ): TestSuite =
   struct
      open X.Case

      type context_t =  unit

      val suite =  collect_testcases (
            "dict_keys"
         ,  [
      ])
   end;
