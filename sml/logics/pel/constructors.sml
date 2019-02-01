use "logics/constructors.sig";

structure PELConstructors : Constructors =
   struct
      datatype Constructor =  Def | Eq | Custom of string

      fun eq(c, d) =  (c = d)
   end;
