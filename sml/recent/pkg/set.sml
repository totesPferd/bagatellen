use "general/contected_eq_type_for_eq_type.fun";
use "general/set.sig";
use "pprint/able.sig";
use "pprint/base.sig";
use "pprint/able_by_construction_a.fun";
use "pprint/construction_a_by_par.fun";
use "pprint/construction_a_for_transition_type.fun";
use "pprint/construction_a.sig";
use "test/assert_eq.fun";
use "test/case.fun";

functor InnerPPrintConstructionAForSet(X:
   sig
      structure Set: Set
      structure Able: PPrintAble
         where type T =  Set.base_t
      structure Base: PPrintBase
         where type state_t =  Able.state_t
      structure ConstructionA: PPrintConstructionA
         where type context_t =  Able.context_t
           and type state_t = Able.state_t
           and type T = Able.T
   end ): PPrintConstructionA =
   PPrintConstructionAForTransitionType(
      struct
         val delim = ","
         open X
         structure TransitionType =  X.Set
      end );

functor PPrintConstructionAForSet(X:
   sig
      structure Set: Set
      structure Able: PPrintAble
         where type T =  Set.base_t
      structure Base: PPrintBase
         where type state_t =  Able.state_t
      structure ConstructionA: PPrintConstructionA
         where type context_t =  Able.context_t
           and type state_t = Able.state_t
           and type T = Able.T
   end ): PPrintConstructionA =
   PPrintConstructionAByPar(
      struct
         val open_par =  "{"
         val close_par =  "}"
         structure Base =  X.Base
         structure ConstructionA =  InnerPPrintConstructionAForSet(X)
      end );

functor PPrintAbleForSet(X:
   sig
      structure Set: Set
      structure Able: PPrintAble
         where type T =  Set.base_t
      structure Base: PPrintBase
         where type state_t =  Able.state_t
      structure ConstructionA: PPrintConstructionA
         where type context_t =  Able.context_t
           and type state_t = Able.state_t
           and type T = Able.T
   end ): PPrintAble =
   PPrintAbleByConstructionA(
      struct
         structure Base =  X.Base
         structure ConstructionA =  PPrintConstructionAForSet(X)
      end );

functor TestAssertEqForSet(X:
   sig
      structure Set: Set
      structure Able: PPrintAble
         where type T =  Set.base_t
      structure Base: PPrintBase
         where type state_t =  Able.state_t
      structure ConstructionA: PPrintConstructionA
         where type context_t =  Able.context_t
           and type state_t = Able.state_t
           and type T = Able.T
      structure EqType: EqType
         where type T =  Able.T
   end ): TestAssertEq =
   TestAssertEq(
      struct
         structure Able = PPrintAbleForSet(X)
         structure Base =  X.Base
         structure CEq =
            ContectedEqTypeForEqType(
               struct
                  type context_t =  X.Able.context_t
                  structure EqType =  X.Set
               end )
         structure Case =
            TestCase(
               struct
                  structure Base =  X.Base
               end )
      end );

