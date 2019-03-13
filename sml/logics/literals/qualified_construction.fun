use "logics/constructors.sig";
use "logics/literals.sig";
use "logics/polymorphic_variables.sig";
use "logics/qualified_construction.sig";
use "logics/variables.sig";

functor QualifiedLiteralsConstruction(X:
   sig
      structure C: Constructors
      structure PCT:
         sig
            type 'a T
         end
      structure Q: Literals
      structure PV: PolymorphicVariables
   end ): QualifiedLiteralsConstruction =
   struct
      structure PolymorphicContainerType =  X.PCT

      structure Constructors =  X.C
      structure Qualifier =  X.Q

      structure Variables =
         struct
            structure Base =
               struct
                  datatype Construction
                     =  Construction of X.C.T * X.Q.PointeredTypeExtended.ContainerType.T * Construction X.PCT.T
                     |  Variable of Construction X.PV.Variable
                  type T =  Construction
               end
            type T =  Base.T X.PV.Variable
            val new: T =  X.PV.new ()
            val eq: T * T -> bool =  X.PV.eq
            val copy: T -> T =  X.PV.copy
            val get_val: T -> Base.T Option.option =  X.PV.get_val
            val is_bound: T -> bool =  Option.isSome o X.PV.get_val
            val is_settable: T -> bool =  X.PV.is_settable
            val set_val: Base.T -> T -> bool =  X.PV.set_val
         end

   end;
