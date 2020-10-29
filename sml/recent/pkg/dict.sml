use "general/contected_eq_type_for_eq_type.fun";
use "general/dict.sig";
use "general/dict_keys.sig";
use "general/eq_type_for_subseteq_type.fun";
use "general/subseteq_type_for_dict.fun";
use "pprint/able_by_construction_a.fun";
use "pprint/able.sig";
use "pprint/base.sig";
use "pprint/construction_a_by_par.fun";
use "pprint/construction_a_for_dict.fun";
use "pprint/construction_a_for_key_val_pair.fun";
use "pprint/construction_a.sig";
use "test/assert_eq.fun";
use "test/case.fun";

functor EqTypeForDict(X:
   sig
      structure DictKeys: DictKeys
      structure ValEqType: EqType
         where type T =  DictKeys.From.val_t
   end ): EqType =
   EqTypeForSubseteqType(
      struct
         structure SubseteqType =  SubseteqTypeForDict(X)
      end );

functor ContectedEqTypeForDict(X:
   sig
      type context_t
      structure DictKeys: DictKeys
      structure ValEqType: EqType
         where type T =  DictKeys.From.val_t
   end ): ContectedEqType =
   ContectedEqTypeForEqType(
      struct
         type context_t =  X.context_t
         structure EqType =  EqTypeForDict(X)
      end );

functor PPrintAbleForKeyValPair(X:
   sig
      structure Base: PPrintBase
      structure KeyAble: PPrintAble
         where type state_t =  Base.state_t
      structure KeyConstructionA: PPrintConstructionA
         where type context_t =  KeyAble.context_t
           and type state_t = Base.state_t
           and type T = KeyAble.T
      structure ValAble: PPrintAble
         where type context_t =  KeyAble.context_t
           and type state_t =  Base.state_t
      structure ValConstructionA: PPrintConstructionA
         where type context_t =  KeyAble.context_t
           and type state_t = Base.state_t
           and type T = ValAble.T
   end ): PPrintAble =
   PPrintAbleByConstructionA(
      struct
         structure Base =  X.Base
         structure ConstructionA = PPrintConstructionAForKeyValPair(X)
      end );

functor InnerPPrintConstructionAForDict(X:
   sig
      structure Base: PPrintBase
      structure DictKeys: DictKeys
      structure KeyAble: PPrintAble
         where type state_t =  Base.state_t
           and type T =  DictKeys.From.key_t
      structure KeyConstructionA: PPrintConstructionA
         where type context_t =  KeyAble.context_t
           and type state_t = Base.state_t
           and type T = KeyAble.T
      structure ValAble: PPrintAble
         where type context_t =  KeyAble.context_t
           and type state_t =  Base.state_t
           and type T =  DictKeys.From.val_t
      structure ValConstructionA: PPrintConstructionA
         where type context_t =  KeyAble.context_t
           and type state_t = Base.state_t
           and type T = ValAble.T
   end ): PPrintConstructionA =
   PPrintConstructionAForDict(
      struct
         structure Base =  X.Base
         structure DictKeys =  X.DictKeys
         structure ConstructionAForKeyValPair =  PPrintConstructionAForKeyValPair(X)
         structure AbleForKeyValPair =  PPrintAbleForKeyValPair(X)
      end );

functor PPrintConstructionAForDict(X:
   sig
      structure Base: PPrintBase
      structure DictKeys: DictKeys
      structure KeyAble: PPrintAble
         where type state_t =  Base.state_t
           and type T =  DictKeys.From.key_t
      structure KeyConstructionA: PPrintConstructionA
         where type context_t =  KeyAble.context_t
           and type state_t = Base.state_t
           and type T = KeyAble.T
      structure ValAble: PPrintAble
         where type context_t =  KeyAble.context_t
           and type state_t =  Base.state_t
           and type T =  DictKeys.From.val_t
      structure ValConstructionA: PPrintConstructionA
         where type context_t =  KeyAble.context_t
           and type state_t = Base.state_t
           and type T = ValAble.T
   end ): PPrintConstructionA =
   PPrintConstructionAByPar(
      struct
         val open_par =  "{"
         val close_par =  "}"
         structure Base =  X.Base
         structure ConstructionA =  InnerPPrintConstructionAForDict(X)
      end );

functor PPrintAbleForDict(X:
   sig
      structure Base: PPrintBase
      structure DictKeys: DictKeys
      structure KeyAble: PPrintAble
         where type state_t =  Base.state_t
           and type T =  DictKeys.From.key_t
      structure KeyConstructionA: PPrintConstructionA
         where type context_t =  KeyAble.context_t
           and type state_t = Base.state_t
           and type T = KeyAble.T
      structure ValAble: PPrintAble
         where type context_t =  KeyAble.context_t
           and type state_t =  Base.state_t
           and type T =  DictKeys.From.val_t
      structure ValConstructionA: PPrintConstructionA
         where type context_t =  KeyAble.context_t
           and type state_t = Base.state_t
           and type T = ValAble.T
   end ): PPrintAble =
   PPrintAbleByConstructionA(
      struct
         structure Base =  X.Base
         structure ConstructionA =  PPrintConstructionAForDict(X)
      end );

functor TestAssertEqForDict(X:
   sig
      structure Base: PPrintBase
      structure DictKeys: DictKeys
      structure KeyAble: PPrintAble
         where type state_t =  Base.state_t
           and type T =  DictKeys.From.key_t
      structure KeyConstructionA: PPrintConstructionA
         where type context_t =  KeyAble.context_t
           and type state_t = Base.state_t
           and type T = KeyAble.T
      structure ValAble: PPrintAble
         where type context_t =  KeyAble.context_t
           and type state_t =  Base.state_t
           and type T =  DictKeys.From.val_t
      structure ValConstructionA: PPrintConstructionA
         where type context_t =  KeyAble.context_t
           and type state_t = Base.state_t
           and type T =  ValAble.T
      structure ValEqType: EqType
         where type T =  ValAble.T
   end ): TestAssertEq =
   TestAssertEq(
      struct
         structure Able = PPrintAbleForDict(X)
         structure Base =  X.Base
         structure CEq =
            ContectedEqTypeForDict(
               struct
                  type context_t =  X.KeyAble.context_t
                  structure DictKeys =  X.DictKeys
                  structure ValEqType =  X.ValEqType
               end )
         structure Case =
            TestCase(
               struct
                  structure Base =  X.Base
               end )
      end );


