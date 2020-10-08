use "collections/string_type.sig";

structure StringType: StringType =
   struct
      type T =  string
      fun point str =  str
      fun eq(s, t) =  (s = t)
   end;
