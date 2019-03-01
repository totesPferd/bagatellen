use "logics/constructors.sig";
use "logics/variables.sig";

signature LiteralsStructure =
   sig
      structure PolymorphicContainerType:
         sig
            type 'a T
         end

      structure Constructors: Constructors
      structure Variables: Variables
         
      datatype Construction =  Construction of Constructors.T * MultiConstruction | Variable of Variables.T
      and      MultiConstruction =  MultiConstruction of Construction PolymorphicContainerType.T

   end;
