use "logics/constructors.sig";
use "logics/variables.sig";

signature LiteralsConstruction =
   sig
      structure PolymorphicContainerType:
         sig
            type 'a T
         end

      structure Constructors: Constructors
      structure Variables: Variables
         
      datatype T =  Construction of Constructors.T * T PolymorphicContainerType.T | Variable of Variables.T

   end;
