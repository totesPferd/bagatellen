use "logics/constructors.sig";

structure QLConstructors : Constructors =
   struct
      datatype T =  Custom of string

      fun eq (c, d) =  (c = d)
   end;
