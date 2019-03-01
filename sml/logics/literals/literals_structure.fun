use "logics/constructors.sig";
use "logics/literals_structure.sig";
use "logics/polymorphic_variables.sig";
use "logics/variables.sig";

functor LiteralsStructure(X:
   sig
      structure C: Constructors
      structure PCT:
         sig
            type 'a T
         end
      structure PV: PolymorphicVariables
   end ): LiteralsStructure =
   struct
      structure PolymorphicContainerType =  X.PCT

      structure Constructors =  X.C

      datatype Construction =  Construction of Constructors.T * MultiConstruction | Variable of Construction X.PV.Variable
      and      MultiConstruction =  MultiConstruction of Construction PolymorphicContainerType.T

      structure Variables =
         struct
            structure Base =
               struct
                  type T =  Construction
               end
            type T =  Base.T X.PV.Variable
            val new: T =  X.PV.new ()
            val eq: T * T -> bool =  X.PV.eq
            val copy: T -> T =  X.PV.copy
            val get_val: T -> Base.T Option.option =  X.PV.get_val
            val is_bound: T -> bool =  Option.isSome o X.PV.get_val
         end

   end;
