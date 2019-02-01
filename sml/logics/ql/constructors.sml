use "logics/constructors.sig";

structure QLConstructors : Constructors =
   struct
      datatype Constructor =  To | Custom of string

      fun eq (c, d) =  (c = d)
   end;
