use "collections/polymorphic_container_type.sig";
use "logics/constructors.sig";
use "logics/literals.sig";
use "logics/polymorphic_variables.sig";
use "logics/qualified_construction.sig";
use "logics/variables.sig";

functor QualifiedLiteralsConstruction(X:
   sig
      structure C: Constructors
      structure PCT: PolymorphicContainerType
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

                  fun get_val (p as Construction(c, _, _)) =  p
                    | get_val (p as Variable x)
                    = case (X.PV.get_val x) of
                         Option.NONE => p
                      |  Option.SOME k => get_val k

                  fun eq(k, l)
                    = case ((get_val k), (get_val l)) of
                        (Construction(c, alpha, xi), Construction(d, beta, ypsilon))
                        => Constructors.eq(c, d) andalso multi_eq((alpha, xi), (beta, ypsilon))
                      | (Construction(c, alpha, xi), Variable y) => false
                      | (Variable x, Construction(d, beta, ypsilon)) => false
                      | (Variable x, Variable y) =>  X.PV.eq (x, y)
                  and multi_eq ((alpha, xi), (beta, ypsilon))
                    =          Qualifier.Multi.eq (alpha, beta)
                        andalso
                               X.PCT.cong eq (xi, ypsilon)

                  structure Single =
                     struct
                        type T =  Construction
                        val eq =  eq
                     end
                  structure Multi =
                     struct
                        type T =  X.Q.PointeredTypeExtended.ContainerType.T * Construction X.PCT.T
                        val eq =  multi_eq
                     end
               end
            type T =  Base.Single.T X.PV.Variable
            val new: T =  X.PV.new ()
            val eq: T * T -> bool =  X.PV.eq
            val copy: T -> T =  X.PV.copy
            val get_val: T -> Base.Single.T Option.option =  X.PV.get_val
            val is_bound: T -> bool =  Option.isSome o X.PV.get_val
            val is_settable: T -> bool =  X.PV.is_settable
            val set_val: Base.Single.T -> T -> bool =  X.PV.set_val
         end

   end;
