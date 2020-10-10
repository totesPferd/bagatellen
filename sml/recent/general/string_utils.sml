use "general/string_utils.sig";

structure StringUtils: StringUtils =
   struct

      fun rep (s, 0) =  ""
        | rep (s, n) =  (rep (s, n - 1)) ^ s

   end
