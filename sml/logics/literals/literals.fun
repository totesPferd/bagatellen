use "collections/occurences.sig";
use "collections/pointered_type_generating.sig";
use "general/base_map.sig";
use "general/type_map.sig";
use "logics/construction.sig";
use "logics/literals.sig";
use "logics/variable_structure.sig";
use "pointered_types/pointered_functor.sig";

functor Literals(X:
   sig
      structure BaseMap: BaseMap
      structure VarMap: TypeMap
      structure VariableStructure: VariableStructure
      structure LiteralsConstruction: LiteralsConstruction
      structure Occ: Occurences
      structure PointeredTypeGenerating: PointeredTypeGenerating
      structure PointeredFunctor: PointeredFunctor
         where
            type Start.ContainerType.T =  PointeredTypeGenerating.PointeredTypeExtended.ContainerType.T
         and
            type End.ContainerType.T =  PointeredTypeGenerating.PointeredTypeExtended.ContainerType.T
      sharing LiteralsConstruction.PolymorphicContainerType = PointeredTypeGenerating.PolymorphicContainerType
      sharing LiteralsConstruction.Variables.Base = PointeredTypeGenerating.PointeredTypeExtended.BaseType
      sharing PointeredFunctor.Start.BaseStructure = PointeredTypeGenerating.PointeredTypeExtended.BaseStructure
      sharing PointeredFunctor.Start.BaseStructureMap = PointeredTypeGenerating.PointeredTypeExtended.BaseStructureMap
      sharing PointeredFunctor.Start.BaseType = PointeredTypeGenerating.PointeredTypeExtended.BaseType
      sharing PointeredFunctor.Start.PointerType = PointeredTypeGenerating.PointeredTypeExtended.PointerType
      sharing PointeredFunctor.End.BaseStructure = PointeredTypeGenerating.PointeredTypeExtended.BaseStructure
      sharing PointeredFunctor.End.BaseStructureMap = PointeredTypeGenerating.PointeredTypeExtended.BaseStructureMap
      sharing PointeredFunctor.End.BaseType = PointeredTypeGenerating.PointeredTypeExtended.BaseType
      sharing PointeredFunctor.End.PointerType = PointeredTypeGenerating.PointeredTypeExtended.PointerType
      sharing PointeredFunctor.Map = BaseMap
      sharing BaseMap.Start = LiteralsConstruction.Variables.Base
      sharing BaseMap.End = LiteralsConstruction.Variables.Base
      sharing VarMap.Start = LiteralsConstruction.Variables
      sharing VarMap.End = LiteralsConstruction.Variables
      sharing BaseMap.Map = PointeredTypeGenerating.PointeredTypeExtended.BaseStructureMap.Map
      sharing VariableStructure.Variables = LiteralsConstruction.Variables
      sharing Occ.DictSet.Eqs =  LiteralsConstruction.Variables
   end ): Literals =
   struct
      structure Constructors =  X.LiteralsConstruction.Constructors
      structure Occurences =  X.Occ
      structure PointeredTypeExtended =  X.PointeredTypeGenerating.PointeredTypeExtended
      structure Variables =  X.LiteralsConstruction.Variables
      structure VariableStructure =  X.VariableStructure
      structure VarMap =  X.VarMap

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
      and multi_eq (xi, ypsilon) =  X.PointeredTypeGenerating.PointeredTypeExtended.ContainerType.eq (xi, ypsilon)

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
      and multi_equate(xi, ypsilon) =  X.PointeredTypeGenerating.PointeredTypeExtended.all_zip (equate) (xi, ypsilon)

      fun vmap f (Variables.Base.Construction(c, xi))
         =  Variables.Base.Construction(c, multi_vmap f xi)
      |   vmap f (Variables.Base.Variable x)
         =  let
               val new_var =  (X.VarMap.apply f) x
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
      and multi_vmap f =  X.PointeredFunctor.map(X.BaseMap.get_map(vmap f))

      val select =  X.PointeredTypeGenerating.PointeredTypeExtended.select
      val is_in  =  X.PointeredTypeGenerating.PointeredTypeExtended.is_in

      val transition =  X.PointeredTypeGenerating.PointeredTypeExtended.transition

      fun get_occurences (X.LiteralsConstruction.Variables.Base.Construction(c, xi)) =  multi_get_occurences xi
      |   get_occurences (X.LiteralsConstruction.Variables.Base.Variable x) =  X.Occ.singleton(x)
      and multi_get_occurences xi
         =  PointeredTypeExtended.transition
              (  fn (t, occ) => Option.SOME (X.Occ.unif_occurences (get_occurences t, occ)))
              xi
              X.Occ.empty

      structure Single =
         struct
            structure Variables =  Variables
            type T =  Variables.Base.Construction
            val eq =  eq
            val equate =  equate
            val get_occurences =  get_occurences
            val vmap =  vmap
         end
      structure Multi =
         struct
            structure Variables =  Variables
            type T =  X.PointeredTypeGenerating.PointeredTypeExtended.ContainerType.T
            val eq =  multi_eq
            val equate =  multi_equate
            val get_occurences =  multi_get_occurences
            val vmap =  multi_vmap
            val empty =  X.PointeredTypeGenerating.PointeredTypeExtended.empty
            val is_empty =  X.PointeredTypeGenerating.PointeredTypeExtended.is_empty
            val subeq =  X.PointeredTypeGenerating.PointeredTypeExtended.subeq

         end

      structure PointerType =  X.PointeredTypeGenerating.PointeredTypeExtended.PointerType

   end;
