use "general/set.sig";
use "pkg/set.sml";
use "pkg/string.sml";
use "pprint/base.sig";
use "test/assert_eq.sig";
use "test/case.sig";
use "testsuites/common.sml";

functor TestAssertEqForStringSet(X:
   sig
      structure Base: PPrintBase
      structure Case: TestCase
         where type state_t = Base.state_t
      structure Set: Set
         where type base_t = string
   end ): TestAssertEq =
   TestAssertEqForSet(
      struct
         structure Case =  X.Case
         structure Set =  X.Set
         type context_t =  context_t
         structure Able =
            PPrintAbleForString(
               struct
                  type context_t =  context_t
                  structure Base =  X.Base
               end )
         structure Base =  X.Base
         structure ConstructionA =
            PPrintConstructionAForString(
               struct
                  type context_t =  context_t
                  structure Base =  X.Base
               end )
         structure EqType =  EqTypeForString
      end );
