use "collections/eqs.sig";
use "collections/type.sig";
use "logics/variables/variables.str";

functor VarEq(T: Type) =
   struct
      structure Type =  T
      structure Variables =  Variables

      type T =  T.T Variables.Variable
      val eq =  Variables.eq
   end;
