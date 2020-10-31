use "general/dict_keys.sig";
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
           and type From.val_t = string
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
           and type T =  DictKeys.To.T
   end ): TestSuite =
   struct
      open X.Case

      type context_t =  unit

      val suite =  collect_testcases (
            "dict_keys"
         ,  [
                  let
                     val in_a = X.DictKeys.From.empty
                     val expected = X.DictKeys.To.empty
                  in
                     X.AssertEqForStringSet.assert("dict_key #1", (), expected, X.DictKeys.keys in_a)
                  end
               ,  let
                     val in_a = ListPair.foldl X.DictKeys.From.set X.DictKeys.From.empty ([ "zwei", "drei", "fuenf" ], [ "2", "3", "5" ])
                     val expected = List.foldl X.DictKeys.To.adjunct X.DictKeys.To.empty [ "zwei", "drei", "fuenf" ]
                  in
                     X.AssertEqForStringSet.assert("dict_key #2", (), expected, X.DictKeys.keys in_a)
                  end ])
   end;
