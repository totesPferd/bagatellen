use "general/dict_set_simple/set.fun";
use "testsuites/set.fun";

structure StringSet =  DictSetSimpleSet(EqTypeForString);

structure SetSuite =  SetSuite (
   struct
      structure Set = StringSet
   end );

structure Suite: TestSuite =  
   struct
      open TestCase

      val suite =  collect_testcases (
            "all"
         ,  [
                  SetSuite.suite ])
   end

val state =  Base.init;

fun main() =
case (#perform Suite.suite)() of
      Option.NONE => ()
   |  Option.SOME f => f(TextIO.stdErr, state);
