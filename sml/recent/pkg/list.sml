use "general/contected_eq_type_for_eq_type.fun";
use "general/eq_type_for_list.fun";
use "general/transition_type_by_list.fun";
use "pprint/able_by_construction_a.fun";
use "pprint/construction_a_by_par.fun";
use "pprint/construction_a_for_transition_type.fun";
use "test/assert_eq.fun";
use "test/case.fun";

functor ContectedEqTypeForList(X:
   sig
      type context_t
      structure EqType: EqType
   end): ContectedEqType =
   ContectedEqTypeForEqType(
      struct
         type context_t =  X.context_t
         structure EqType =  EqTypeForList(X)
      end );

functor InnerPPrintConstructionAForList(X:
   sig
      structure Able: PPrintAble
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
         structure TransitionType =
            TransitionTypeByList(
               struct
                  type base_t =  X.Able.T
               end )
      end );

functor PPrintConstructionAForList(X:
   sig
      structure Able: PPrintAble
      structure Base: PPrintBase
         where type state_t =  Able.state_t
      structure ConstructionA: PPrintConstructionA
         where type context_t =  Able.context_t
           and type state_t = Able.state_t
           and type T = Able.T
   end ): PPrintConstructionA =
   PPrintConstructionAByPar(
      struct
         val open_par =  "["
         val close_par =  "]"
         structure Base =  X.Base
         structure ConstructionA =  InnerPPrintConstructionAForList(X)
      end );

functor PPrintAbleForList(X:
   sig
      structure Able: PPrintAble
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
         structure ConstructionA =  PPrintConstructionAForList(X)
      end );

functor TestAssertEqForList(X:
   sig
      structure Able: PPrintAble
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
         structure Able = PPrintAbleForList(X)
         structure Base =  X.Base
         structure CEq =
            ContectedEqTypeForList(
               struct
                  type context_t =  X.Able.context_t
                  structure EqType =  X.EqType
               end )
         structure Case =
            TestCase(
               struct
                  structure Base =  X.Base
               end )
      end );
