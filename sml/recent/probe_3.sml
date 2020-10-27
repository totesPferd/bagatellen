use "general/dict_set_simple/set.fun";
use "testsuites/set.fun";

structure StringSet =  DictSetSimpleSet(EqTypeForString);

type context_t =  unit;

structure Suite =  Suite (
   struct
      type context_t = context_t
      structure Set = StringSet
   end );

(#perform Suite.suite)()
