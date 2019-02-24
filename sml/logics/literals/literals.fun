use "collections/dictset.fun";
use "collections/occurences.fun";
use "collections/pointered_type.fun";
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
            val new =  X.PV.new ()
            val eq =  X.PV.eq
            val copy =  X.PV.copy
            val get_val =  X.PV.get_val
            val is_bound =  Option.isSome o X.PV.get_val
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

      structure BaseType =
         struct
            type T =  Construction
            fun eq(k, l)
              = case ((get_val k), (get_val l)) of
                  (Construction(c, xi), Construction(d, ypsilon))
                  => X.C.eq(c, d) andalso multi_eq(xi, ypsilon)
                | (Construction(c, xi), Variable y) => false
                | (Variable x, Construction(d, ypsilon)) => false
                | (Variable x, Variable y) =>  Variables.eq (x, y)
            and multi_eq (xi, ypsilon) =  X.PPT.ContainerType.polymorphic_eq (eq) (xi, ypsilon)
         end

      structure PointeredType =  PointeredType(
         struct
            structure B =  BaseType
            structure PPT =  X.PPT
         end )

      structure DictSet =  DictSet(Variables)
      structure Occurences =  Occurences(DictSet)

      structure PointerType =  PointeredType.PointerType

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
      and multi_equate(xi, ypsilon) =  PointeredType.all_zip (equate) (xi, ypsilon)

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
      and multi_vmap f =  PointeredType.map (vmap f)

      fun get_occurences (Construction(c, xi))
         =  multi_get_occurences xi
      |   get_occurences (Variable x)
         =  Occurences.singleton(x)
      and multi_get_occurences xi
         = PointeredType.transition
              (  fn (t, occ) => Option.SOME (Occurences.unif_occurences (get_occurences t, occ)) )
              xi
              Occurences.empty

      structure Single =
         struct
            structure BaseType =  BaseType
            structure Variables =  Variables

            type T =  Construction

            fun variable v =  Variable v
            val eq =  BaseType.eq

            val equate =  equate
            val vmap =  vmap

            val get_occurences =  get_occurences

            val traverse =  traverse
         end

      structure Multi =
         struct
            structure Variables =  Variables

            type T =  PointeredType.ContainerType.T

            val equate =  multi_equate
            val eq =  BaseType.multi_eq
            val empty =  PointeredType.empty
            val is_empty =  PointeredType.is_empty
            val subeq =  PointeredType.subeq

            val vmap =  multi_vmap

            val get_occurences =  multi_get_occurences

            val traverse =  multi_traverse
         end

      val select =  PointeredType.select

      val fe =  PointeredType.fe
      val fop =  PointeredType.fop
      val is_in  =  PointeredType.is_in

      fun construct (c, m) =  Construction(c, m)
      val transition =  PointeredType.transition

   end;
