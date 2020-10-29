use "pkg/base.sml";
use "test/assert.fun";
use "test/case.fun";
use "test/suite.sig";

type context_t =  unit;

structure TestCase =  TestCase(
   struct
      structure Base = Base
   end );

structure TestAssert =  TestAssert(
   struct
      structure Base = Base
      structure Case = TestCase
   end );


