use "collections/polymorphic_pointered_type.sig";
use "logics/constructors.sig";
use "logics/literals.sig";
use "logics/polymorphic_variables.sig";

functor Literals(X:
   sig
      structure C:   Constructors
      structure PPT: PolymorphicPointeredType
      structure PV:  PolymorphicVariables
   end ): Literals =
   struct
      structure Constructors =  X.C

      datatype Construction =  Construction of Constructors.T * Construction X.PPT.ContainerType.T | Variable of Construction X.PV.Variable

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

      fun traverse (f_1, f_2, f_3, z_0) (Construction(c, xi))
         =  f_1(c, multi_traverse(f_1, f_2, f_3, z_0) xi)
      |   traverse (f_1, f_2, f_3, z_0) (Variable x)
         =  f_2(x)
      and multi_traverse (f_1, f_2, f_3, z_0) xi
         = X.PPT.transition
              (fn (s, r) =>  f_3(traverse(f_1, f_2, f_3, z_0) s, r))
              xi z_0

      fun get_val (p as Construction(c, xi)) =  p
        | get_val (p as Variable x)
        = case (X.PV.get_val x) of
             Option.NONE => p
          |  Option.SOME k => get_val k

      fun eq(k, l)
        = case ((get_val k), (get_val l)) of
            (Construction(c, xi), Construction(d, ypsilon))
            => X.C.eq(c, d) andalso multi_eq(xi, ypsilon)
          | (Construction(c, xi), Variable y) => false
          | (Variable x, Construction(d, ypsilon)) => false
          | (Variable x, Variable y) =>  Variables.eq (x, y)
      and multi_eq (xi, ypsilon) =  X.PPT.ContainerType.polymorphic_eq (eq) (xi, ypsilon)

      fun equate(k, l)
        = case (get_val k, get_val l) of
             (Construction(c, xi), Construction(d, ypsilon))
          => if X.C.eq(c, d)
             then
               multi_equate(xi, ypsilon)
            else
               false
          |  (Construction(c, xi), Variable y) =>  false
          |  (Variable x, l)
          => X.PV.set_val l x
      and multi_equate(xi, ypsilon) =  X.PPT.all_zip (equate) (xi, ypsilon)

      fun vmap f (Construction(c, xi))
         =  Construction(c, multi_vmap f xi)
      |   vmap f (Variable x)
         =  let
               val new_var =  f x
            in (  (  if (X.PV.is_settable new_var)
                     then
                        let
                           val kval =  X.PV.get_val x
                        in if Option.isSome kval
                           then
                              let
                                 val new_value =  vmap f (Option.valOf kval)
                              in (
                                    X.PV.set_val (new_var, new_value)
                                 ;  () )
                              end
                           else
                              ()
                        end
                     else
                        () )
                  ;  Variable new_var )
            end
      and multi_vmap f =  X.PPT.map (vmap f)

     val select =  X.PPT.select

      val fe =  X.PPT.fe
      val fop =  X.PPT.p_fop (eq)
      val is_in  =  X.PPT.p_is_in (eq)

      fun construct (c, m) =  Construction(c, m)
      val transition =  X.PPT.transition

      structure Single =
         struct
            structure Variables =  Variables
            type T =  Construction
            val traverse =  traverse
            val eq =  eq
            val equate =  equate
            val variable =  Variable
            val vmap =  vmap
         end
      structure Multi =
         struct
            structure Variables =  Variables
            type T =  Construction X.PPT.ContainerType.T
            val traverse =  multi_traverse
            val eq =  multi_eq
            val equate =  multi_equate
            val vmap =  multi_vmap
            val empty =  X.PPT.empty ()
            val is_empty =  X.PPT.is_empty
            val subeq =  X.PPT.p_subeq (Single.eq)

         end
      structure PointerType =  X.PPT.PointerType

   end;
