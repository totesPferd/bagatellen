use "general/dict_set_simple/dict.fun";
use "general/dict_set_simple/dict_keys.fun";
use "general/dict_set_simple/set.fun";
use "testsuites/dict_keys.fun";
use "testsuites/set.fun";

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
      structure Assert = TestAssert
      structure Base = Base
      structure Case = TestCase
      structure DictKeys =  StringStringDictKeys
      structure Set = StringSet
   end );
structure SetSuite =  SetSuite (
   struct
      structure Assert = TestAssert
      structure Base = Base
      structure Case = TestCase
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
