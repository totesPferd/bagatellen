use "general/dict_set_simple/dict.fun";
use "general/dict_set_simple/dict_keys.fun";
use "general/dict_set_simple/set.fun";
use "testsuites/dict_keys.fun";
use "testsuites/set.fun";
use "testsuites/test_assert_eq_for_string_set.fun";
use "testsuites/test_assert_eq_for_string_string_dict.fun";


structure StringSet =  DictSetSimpleSet(EqTypeForString);

structure StringStringDict =  DictSetSimpleDict (
   struct
      structure K = EqTypeForString
      type val_t = string
   end );
structure StringStringDictKeys =  DictSetSimpleDictKeys (
   struct
      structure D =  StringStringDict
      structure S =  StringSet
   end );

structure Common =
   struct
      type context_t =  context_t
      structure Assert = TestAssert
      structure AssertEqForString =  TestAssertEqForString(
         struct
            type context_t = context_t
            structure Base =  Base
            structure Case =  TestCase
         end );
      structure Base = Base
      structure Case = TestCase
      structure DictKeys =  StringStringDictKeys
      structure Set =  StringSet
   end;

structure TestAssertEqForStringSet =  TestAssertEqForStringSet(Common)

structure DictKeysSuite =  DictKeysSuite (
   struct
      open Common
      structure AssertEqForStringSet =  TestAssertEqForStringSet
   end );
structure SetSuite =  SetSuite (
   struct
      open Common
      structure AssertEqForStringSet =  TestAssertEqForStringSet
   end );

structure Suite: TestSuite =  
   struct
      open TestCase

      val suite =  collect_testcases (
            "all"
         ,  [
                  DictKeysSuite.suite
               ,  SetSuite.suite ])
   end

val state =  Base.init;

fun main() =
case (#perform Suite.suite)() of
      Option.NONE => ()
   |  Option.SOME f => f(TextIO.stdErr, state);
