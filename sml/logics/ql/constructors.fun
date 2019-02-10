use "logics/constructors.sig";
use "logics/ql/modules.sig";
use "logics/ql/qualifier.sig";

functor QLConstructors (X:
   sig
      structure M: Modules
      structure Q: Qualifier
   end ): Constructors =
   struct
      datatype T =  Module of X.M.T | Qualifier of X.Q.T

      fun eq(Module m, Module n) =  X.M.eq(m, n)
        | eq(Module m, Qualifier q) =  false
        | eq(Qualifier p, Module n) =  false
        | eq(Qualifier p, Qualifier q) =  X.Q.eq(p, q)

   end;
