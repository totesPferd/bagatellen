use "general/dict_set_simple/set.fun";
use "testsuites/set.fun";

structure StringSet =  DictSetSimpleSet(EqTypeForString);

structure Suite =  Suite (
   struct
      structure Set = StringSet
   end );

val state =  Base.init;

case (#perform Suite.suite)() of
      Option.NONE => ()
   |  Option.SOME f => f(TextIO.stdErr, state);
