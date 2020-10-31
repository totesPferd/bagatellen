use "pkg/base.sml";
use "test/case.fun";

type context_t =  unit;

structure TestCase =  TestCase(
   struct
      structure Base = Base
   end );
