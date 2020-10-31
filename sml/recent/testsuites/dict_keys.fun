use "general/dict_keys.sig";
use "pkg/dict.sml";
use "pkg/string.sml";
use "testsuites/common.sml";
use "testsuites/test_assert_for_string_set.fun";

functor DictKeysSuite(X:
   sig
      structure DictKeys: DictKeys
         where type From.key_t = string
         where type From.val_t = string
      structure Set: Set
         where type base_t = string
   end ): TestSuite =
   struct
      open TestCase

      type context_t =  context_t
      structure TestAssertEqForStringSet =  TestAssertEqForStringSet(X)
      structure TestAssertEqForString =  TestAssertEqForString(
         struct
            type context_t =  context_t
            structure Base = Base
         end )

      val suite =  collect_testcases (
            "set"
         ,  [
      ])
   end;
