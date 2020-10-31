use "general/dict_keys.sig";
use "pkg/dict.sml";
use "pkg/string.sml";
use "pprint/base.sig";
use "test/assert_eq.sig";
use "testsuites/common.sml";

functor TestAssertEqForStringStringDict(X:
   sig
      structure Base: PPrintBase
      structure DictKeys: DictKeys
   end ): TestAssertEq =
   TestAssertEqForDict(
      struct
         structure DictKeys =  X.DictKeys
         structure Base =  X.Base
         structure KeyAble =  PPrintAbleForString(
            struct
               type context_t =  context_t
               structure Base =  X.Base
            end )
         structure KeyConstructionA = PPrintConstructionAForString(
            struct
               type context_t =  context_t
               structure Base =  X.Base
            end )
         structure ValAble =  PPrintAbleForString(
            struct
               type context_t =  context_t
               structure Base =  X.Base
            end )
         structure ValConstructionA = PPrintConstructionAForString(
            struct
               type context_t =  context_t
               structure Base =  X.Base
            end )
         structure ValEqType =  EqTypeForString
      end );
