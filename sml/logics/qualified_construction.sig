use "logics/constructors.sig";
use "logics/literals.sig";
use "logics/variables.sig";

signature QualifiedLiteralsConstruction =
   sig
      structure PolymorphicContainerType:
         sig
            type 'a T
         end

      structure Constructors: Constructors
      structure Qualifier: Literals
         
      structure Variables:
         sig
            type T
            structure Base:
               sig
                  datatype Construction
                     =  Construction of Constructors.T * Qualifier.PointeredTypeExtended.ContainerType.T * Construction PolymorphicContainerType.T
                     |  Variable of T
                  type T =  Construction
               end

            val new:         T
            val eq:          T * T -> bool
            val copy:        T -> T
            val get_val:     T -> Base.T Option.option
            val is_bound:    T -> bool
            val is_settable: T -> bool
            val set_val:     Base.T -> T -> bool
         end

   end;
