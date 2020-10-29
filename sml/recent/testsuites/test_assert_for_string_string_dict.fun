use "general/dict_keys.sig";
use "pkg/dict.sml";
use "pkg/string.sml";
use "test/assert_eq.sig";
use "testsuites/common.sml";

functor TestAssertForStringStringDict(X:
   sig
      structure DictKeys: DictKeys
   end ): TestAssertEq =
   TestAssertEqForDict(
      struct
         open X
         structure Base =  Base
         structure KeyAble =  PPrintAbleForString(
            struct
               type context_t =  context_t
               structure Base =  Base
            end )
         structure KeyConstructionA = PPrintConstructionAForString(
            struct
               type context_t =  context_t
               structure Base =  Base
            end )
         structure ValAble =  PPrintAbleForString(
            struct
               type context_t =  context_t
               structure Base =  Base
            end )
         structure ValConstructionA = PPrintConstructionAForString(
            struct
               type context_t =  context_t
               structure Base =  Base
            end )
         structure ValEqType =  EqTypeForString
      end );
