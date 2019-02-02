use "logics/constructors.sig";

structure QLConstructors : Constructors =
   struct
      datatype Constructor =  Custom of string

      fun eq (c, d) =  (c = d)
   end;
