use "collections/pointer_type.sig";
use "logics/constructors.sig";
use "logics/polymorphic_variables.sig";

signature LiteralsIn =
   sig
      structure C:  Constructors
      structure PT: PointerType
      structure PV: PolymorphicVariables

      datatype T =  Construction of C.T * PT.ContainerType.T | Variable of T PV.Variable

      val destruct: PT.BaseType.T -> T

   end;
