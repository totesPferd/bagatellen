use "collections/eqs.sig";
use "collections/type.sig";
use "logics/variables.sig";

functor VariablesAsEq(X:
   sig
      structure T: Type
      structure V: Variables
   end ): Eqs =
   struct
      structure Type =  X.T
      structure Variables =  X.V

      type T =  Type.T Variables.Variable
      val eq =  Variables.eq
   end;
