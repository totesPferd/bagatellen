use "general/dict_set_simple/dict.fun";
use "general/dict_set_simple/dict_keys.fun";
use "general/dict_set_simple/set.fun";
use "testsuites/dict_keys.fun";
use "testsuites/set.fun";

structure Common =
   struct
      structure Assert = TestAssert
      structure AssertEqForString =  TestAssertEqForString(
         struct
            type context_t = context_t
            structure Base =  Base
            structure Case =  TestCase
         end );
      structure Base = Base
      structure Case = TestCase
   end;

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

structure DictKeysSuite =  DictKeysSuite (
   struct
      open Common
      structure DictKeys =  StringStringDictKeys
      structure Set = StringSet
   end );
structure SetSuite =  SetSuite (
   struct
      open Common
      structure Set = StringSet
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
