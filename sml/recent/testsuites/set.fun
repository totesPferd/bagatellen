use "pkg/base.sml";
use "pkg/set.sml";
use "pkg/string.sml";
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

functor TestAssertEqForStringSet(X:
   sig
      structure Set: Set
         where type base_t = string
   end ): TestAssertEq =
   TestAssertEqForSet(
      struct
         open X
         type context_t =  context_t
         structure Able =  
            PPrintAbleForString(
               struct
                  type context_t =  context_t
                  structure Base =  Base
               end )
         structure Base =  Base
         structure ConstructionA =
            PPrintConstructionAForString(
               struct
                  type context_t =  context_t
                  structure Base =  Base
               end )
         structure EqType =  EqTypeForString
      end );

functor Suite(X:
   sig
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
