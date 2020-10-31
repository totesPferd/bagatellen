use "general/set.sig";
use "pkg/set.sml";
use "pkg/string.sml";
use "test/assert_eq.sig";
use "testsuites/common.sml";

functor TestAssertEqForStringSet(X:
   sig
      structure Set: Set
         where type base_t = string
   end ): TestAssertEq =
   TestAssertEqForSet(
      struct
         structure Set =  X.Set
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
