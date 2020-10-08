use "logics/constructors.sig";

structure PELConstructors : Constructors =
   struct
      datatype T =  Def | Eq | Custom of string

      fun eq(c, d) =  (c = d)
   end;
