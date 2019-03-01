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
         
      datatype Construction =  Construction of Constructors.T * Construction PolymorphicContainerType.T | Variable of Variables.T

   end;
