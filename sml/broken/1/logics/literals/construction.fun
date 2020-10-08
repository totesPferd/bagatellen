use "collections/polymorphic_container_type.sig";
use "logics/constructors.sig";
use "logics/construction.sig";
use "logics/polymorphic_variables.sig";
use "logics/variables.sig";

functor LiteralsConstruction(X:
   sig
      structure C: Constructors
      structure PCT: PolymorphicContainerType
      structure PV: PolymorphicVariables
   end ): LiteralsConstruction =
   struct
      structure PolymorphicContainerType =  X.PCT

      structure Constructors =  X.C

      structure Variables =
         struct
            structure Base =
               struct
                  datatype Construction =  Construction of X.C.T * Construction X.PCT.T | Variable of Construction X.PV.Variable

                  fun get_val (p as Construction(c, xi)) =  p
                    | get_val (p as Variable x)
                    = case (X.PV.get_val x) of
                         Option.NONE => p
                      |  Option.SOME k => get_val k

                  fun eq(k, l)
                    = case ((get_val k), (get_val l)) of
                        (Construction(c, xi), Construction(d, ypsilon))
                        => Constructors.eq(c, d) andalso multi_eq(xi, ypsilon)
                      | (Construction(c, xi), Variable y) => false
                      | (Variable x, Construction(d, ypsilon)) => false
                      | (Variable x, Variable y) =>  X.PV.eq (x, y)
                  and multi_eq (xi, ypsilon) =  X.PCT.cong eq (xi, ypsilon)

                  structure Single =
                     struct
                        type T =  Construction
                        val eq =  eq
                     end
                  structure Multi =
                     struct
                        type T =  Construction X.PCT.T
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
