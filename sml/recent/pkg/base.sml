use "general/string_utils.sml";
use "pprint/base.fun";
use "pprint/config.sig";

structure Config: PPrintConfig =
   struct
      val indent = 3
      val page_width = 72
   end;

structure Base: PPrintBase =
   PPrintBase(
      struct
         structure Config = Config
         structure StringUtils = StringUtils
      end );
