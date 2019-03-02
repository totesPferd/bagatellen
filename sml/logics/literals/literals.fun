use "collections/pointered_type_generating.sig";
use "collections/polymorphic_pointered_type.sig";
use "logics/construction.sig";
use "logics/literals.sig";

functor Literals(X:
   sig
      structure LiteralsConstruction: LiteralsConstruction
      structure PointeredTypeGenerating: PointeredTypeGenerating
      sharing LiteralsConstruction.PolymorphicContainerType = PointeredTypeGenerating.PolymorphicContainerType
      sharing LiteralsConstruction.Variables.Base =  PointeredTypeGenerating.PointeredType.BaseType
   end ): Literals =
   struct
      structure Constructors =  X.LiteralsConstruction.Constructors
      structure Variables =  X.LiteralsConstruction.Variables

      fun traverse (f_1, f_2, f_3, z_0) (Variables.Base.Construction(c, xi))
         =  f_1(c, multi_traverse(f_1, f_2, f_3, z_0) xi)
      |   traverse (f_1, f_2, f_3, z_0) (Variables.Base.Variable x)
         =  f_2(x)
      and multi_traverse (f_1, f_2, f_3, z_0) xi
         = X.PointeredTypeGenerating.PointeredType.transition
              (fn (s, r) =>  f_3(traverse(f_1, f_2, f_3, z_0) s, r))
              xi z_0

      fun get_val (p as Variables.Base.Construction(c, xi)) =  p
        | get_val (p as Variables.Base.Variable x)
        = case (Variables.get_val x) of
             Option.NONE => p
          |  Option.SOME k => get_val k

      fun eq(k, l)
        = case ((get_val k), (get_val l)) of
            (Variables.Base.Construction(c, xi), Variables.Base.Construction(d, ypsilon))
            => Constructors.eq(c, d) andalso multi_eq(xi, ypsilon)
          | (Variables.Base.Construction(c, xi), Variables.Base.Variable y) => false
          | (Variables.Base.Variable x, Variables.Base.Construction(d, ypsilon)) => false
          | (Variables.Base.Variable x, Variables.Base.Variable y) =>  Variables.eq (x, y)
      and multi_eq (xi, ypsilon) =  X.PointeredTypeGenerating.PointeredType.ContainerType.eq (xi, ypsilon)

      fun equate(k, l)
        = case (get_val k, get_val l) of
             (Variables.Base.Construction(c, xi), Variables.Base.Construction(d, ypsilon))
          => if Constructors.eq(c, d)
             then
               multi_equate(xi, ypsilon)
            else
               false
          |  (Variables.Base.Construction(c, xi), Variables.Base.Variable y) =>  false
          |  (Variables.Base.Variable x, l)
          => Variables.set_val l x
      and multi_equate(xi, ypsilon) =  X.PointeredTypeGenerating.PointeredType.all_zip (equate) (xi, ypsilon)

      fun vmap f (Variables.Base.Construction(c, xi))
         =  Variables.Base.Construction(c, multi_vmap f xi)
      |   vmap f (Variables.Base.Variable x)
         =  let
               val new_var =  f x
            in (  (  if (Variables.is_settable new_var)
                     then
                        let
                           val kval =  Variables.get_val x
                        in if Option.isSome kval
                           then
                              let
                                 val new_value =  vmap f (Option.valOf kval)
                              in (
                                    Variables.set_val new_value new_var
                                 ;  () )
                              end
                           else
                              ()
                        end
                     else
                        () )
                  ;  Variables.Base.Variable new_var )
            end
      and multi_vmap f =  X.PointeredTypeGenerating.PointeredType.map (vmap f)

      val select =  X.PointeredTypeGenerating.PointeredType.select

      val fe =  X.PointeredTypeGenerating.PointeredType.fe
      val fop =  X.PointeredTypeGenerating.PointeredType.fop
      val is_in  =  X.PointeredTypeGenerating.PointeredType.is_in

      fun construct (c, m) =  Variables.Base.Construction(c, m)
      val transition =  X.PointeredTypeGenerating.PointeredType.transition

      structure Single =
         struct
            structure Variables =  Variables
            type T =  Variables.Base.Construction
            val traverse =  traverse
            val eq =  eq
            val equate =  equate
            val variable =  Variables.Base.Variable
            val vmap =  vmap
         end
      structure Multi =
         struct
            structure Variables =  Variables
            type T =  X.PointeredTypeGenerating.PointeredType.ContainerType.T
            val traverse =  multi_traverse
            val eq =  multi_eq
            val equate =  multi_equate
            val vmap =  multi_vmap
            val empty =  X.PointeredTypeGenerating.PointeredType.empty
            val is_empty =  X.PointeredTypeGenerating.PointeredType.is_empty
            val subeq =  X.PointeredTypeGenerating.PointeredType.subeq

         end

      structure PointerType =  X.PointeredTypeGenerating.PointeredType.PointerType

   end;
