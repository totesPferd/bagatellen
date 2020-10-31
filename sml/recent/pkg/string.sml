use "general/canonical_eq_type.fun";
use "general/contected_eq_type_for_eq_type.fun";
use "pprint/able_by_construction_a.fun";
use "pprint/construction_a_for_string.fun";
use "test/assert_eq.fun";
use "test/case.sig";


structure EqTypeForString =  CanonicalEqType(
   struct
      type T =  string
   end );

functor ContectedEqTypeForString(X:
   sig
      type context_t
   end): ContectedEqType =
   ContectedEqTypeForEqType(
      struct
         type context_t =  X.context_t
         structure EqType =  EqTypeForString
      end );

functor PPrintAbleForString(X:
   sig
      type context_t
      structure Base: PPrintBase
   end ): PPrintAble =
   PPrintAbleByConstructionA(
      struct
         structure Base =  X.Base
         structure ConstructionA =  PPrintConstructionAForString(X)
      end );

functor TestAssertEqForString(X:
   sig
      type context_t
      structure Base: PPrintBase
      structure Case: TestCase
         where type state_t =  Base.state_t
   end): TestAssertEq =
   TestAssertEq(
      struct
         structure Base =  X.Base
         structure Able =  PPrintAbleForString(X)
         structure CEq =  ContectedEqTypeForString(X)
         structure Case =  X.Case
      end );
