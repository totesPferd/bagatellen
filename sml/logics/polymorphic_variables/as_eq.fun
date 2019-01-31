use "collections/eqs.sig";
use "collections/type.sig";
use "logics/polymorphic_variables.sig";

functor PolymorphicVariablesAsEq(X:
   sig
      structure T: Type
      structure V: PolymorphicVariables
   end ): Eqs =
   struct
      structure Type =  X.T
      structure PolymorphicVariables =  X.V

      type T =  Type.T PolymorphicVariables.Variable
      val eq =  PolymorphicVariables.eq
   end;
