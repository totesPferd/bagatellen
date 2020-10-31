use "general/dict_keys.sig";
use "pkg/dict.sml";
use "pkg/string.sml";
use "pprint/base.sig";
use "test/assert.sig";
use "test/case.sig";
use "testsuites/test_assert_eq_for_string_set.fun";

functor DictKeysSuite(X:
   sig
      structure Base: PPrintBase
      structure Case: TestCase
         where type state_t =  Base.state_t
      structure DictKeys: DictKeys
         where type From.key_t = string
         where type From.val_t = string
      structure Set: Set
         where type base_t = string
   end ): TestSuite =
   struct
      open X.Case

      type context_t =  context_t
      structure TestAssert =  TestAssert(X)
      structure TestAssertEqForStringSet =  TestAssertEqForStringSet(X)
      structure TestAssertEqForString =  TestAssertEqForString(
         struct
            type context_t =  context_t
            structure Base = X.Base
            structure Case = X.Case
         end )

      val suite =  collect_testcases (
            "dict_keys"
         ,  [
      ])
   end;
