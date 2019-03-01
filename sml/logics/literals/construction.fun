use "logics/constructors.sig";
use "logics/construction.sig";
use "logics/polymorphic_variables.sig";
use "logics/variables.sig";

functor LiteralsConstruction(X:
   sig
      structure C: Constructors
      structure PCT:
         sig
            type 'a T
         end
      structure PV: PolymorphicVariables
   end ): LiteralsConstruction =
   struct
      structure PolymorphicContainerType =  X.PCT

      structure Constructors =  X.C

      datatype Construction =  Construction of Constructors.T * Construction PolymorphicContainerType.T | Variable of Construction X.PV.Variable

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
