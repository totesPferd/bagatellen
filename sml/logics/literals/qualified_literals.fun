use "collections/double_pointered_type_extended.sig";
use "collections/occurences.sig";
use "collections/pointered_type_generating.sig";
use "general/base_map.sig";
use "general/type_map.sig";
use "logics/double_variable_structure.sig";
use "logics/literals.sig";
use "logics/qualified_construction.sig";
use "pointered_types/pointered_functor.sig";

functor QualifiedLiterals(X:
   sig
      structure LiteralsConstruction: QualifiedLiteralsConstruction
      structure PointeredTypeGenerating:  PointeredTypeGenerating
      structure DoublePointeredTypeExtended:  DoublePointeredTypeExtended
         where type SndType.ContainerType.T = PointeredTypeGenerating.PointeredTypeExtended.ContainerType.T
      structure DoubleVariableStructure:  DoubleVariableStructure
      structure VariableStructure:  VariableStructure
      structure BaseMap: BaseMap
      structure VarMap: TypeMap
      structure PointeredFunctor:  PointeredFunctor
         where type Start.ContainerType.T =  PointeredTypeGenerating.PointeredTypeExtended.ContainerType.T
         and   type End.ContainerType.T =  PointeredTypeGenerating.PointeredTypeExtended.ContainerType.T
      structure Occ: Occurences
      sharing LiteralsConstruction.PolymorphicContainerType = PointeredTypeGenerating.PolymorphicContainerType
      sharing LiteralsConstruction.Variables.Base = PointeredTypeGenerating.PointeredTypeExtended.BaseType
      sharing DoublePointeredTypeExtended.FstType = LiteralsConstruction.Qualifier.PointeredTypeExtended
      sharing DoublePointeredTypeExtended.SndType.BaseType = PointeredTypeGenerating.PointeredTypeExtended.BaseType
      sharing DoublePointeredTypeExtended.SndType.PointerType = PointeredTypeGenerating.PointeredTypeExtended.PointerType
      sharing DoublePointeredTypeExtended.SndType.BaseStructure = PointeredTypeGenerating.PointeredTypeExtended.BaseStructure
      sharing DoublePointeredTypeExtended.SndType.BaseStructureMap = PointeredTypeGenerating.PointeredTypeExtended.BaseStructureMap
      sharing DoublePointeredTypeExtended.BaseType = DoubleVariableStructure.BaseType
      sharing DoubleVariableStructure.Variables.Fst = LiteralsConstruction.Qualifier.VariableStructure
      sharing DoubleVariableStructure.Variables.Snd = VariableStructure
      sharing VariableStructure.Variables = LiteralsConstruction.Variables
      sharing PointeredFunctor.Start.BaseStructure = PointeredTypeGenerating.PointeredTypeExtended.BaseStructure
      sharing PointeredFunctor.Start.BaseStructureMap = PointeredTypeGenerating.PointeredTypeExtended.BaseStructureMap
      sharing PointeredFunctor.Start.BaseType = PointeredTypeGenerating.PointeredTypeExtended.BaseType
      sharing PointeredFunctor.Start.PointerType = PointeredTypeGenerating.PointeredTypeExtended.PointerType
      sharing PointeredFunctor.End.BaseStructure = PointeredTypeGenerating.PointeredTypeExtended.BaseStructure
      sharing PointeredFunctor.End.BaseStructureMap = PointeredTypeGenerating.PointeredTypeExtended.BaseStructureMap
      sharing PointeredFunctor.End.BaseType = PointeredTypeGenerating.PointeredTypeExtended.BaseType
      sharing PointeredFunctor.End.PointerType = PointeredTypeGenerating.PointeredTypeExtended.PointerType
      sharing PointeredFunctor.Map = BaseMap
      sharing VariableStructure.Map = VarMap
      sharing BaseMap.Start = LiteralsConstruction.Variables.Base
      sharing BaseMap.End = LiteralsConstruction.Variables.Base
      sharing VarMap.Start = LiteralsConstruction.Variables
      sharing VarMap.End = LiteralsConstruction.Variables
      sharing Occ.DictSet.Eqs =  LiteralsConstruction.Variables
   end ): Literals =
   struct
      structure Constructors =  X.LiteralsConstruction.Constructors

      structure Occurences =  X.Occ
      structure PointeredTypeExtended =  X.DoublePointeredTypeExtended
      structure Variables =  X.LiteralsConstruction.Variables
      structure VariableStructure =  X.DoubleVariableStructure

      fun get_val (p as Variables.Base.Construction(c, _, _)) =  p
        | get_val (p as Variables.Base.Variable x)
        = case (Variables.get_val x) of
             Option.NONE => p
          |  Option.SOME k => get_val k

      fun eq(k, l)
        = case ((get_val k), (get_val l)) of
            (Variables.Base.Construction(c, alpha, xi), Variables.Base.Construction(d, beta, ypsilon))
            => Constructors.eq(c, d) andalso multi_eq((alpha, xi), (beta, ypsilon))
          | (Variables.Base.Construction(c, alpha, xi), Variables.Base.Variable y) => false
          | (Variables.Base.Variable x, Variables.Base.Construction(d, beta, ypsilon)) => false
          | (Variables.Base.Variable x, Variables.Base.Variable y) =>  Variables.eq (x, y)
      and multi_eq ((alpha, xi), (beta, ypsilon))
        =          X.LiteralsConstruction.Qualifier.Multi.eq (alpha, beta)
            andalso
                   X.PointeredTypeGenerating.PointeredTypeExtended.ContainerType.eq (xi, ypsilon)
                   
      fun equate(k, l)
        = case (get_val k, get_val l) of
             (Variables.Base.Construction(c, alpha, xi), Variables.Base.Construction(d, beta, ypsilon))
          => if Constructors.eq(c, d)
             then
               multi_equate((alpha, xi), (beta, ypsilon))
            else
               false
          |  (Variables.Base.Construction(c, alpha, xi), Variables.Base.Variable y) =>  false
          |  (Variables.Base.Variable x, l)
          => Variables.set_val l x
      and multi_equate((alpha, xi), (beta, ypsilon))
         =        X.LiteralsConstruction.Qualifier.Multi.equate (alpha, beta)
            andalso
                  X.PointeredTypeGenerating.PointeredTypeExtended.all_zip equate (xi, ypsilon)
      val single_equate =  equate

      fun vmap f (Variables.Base.Construction(c, alpha, xi))
         =   let
                val (beta, ypsilon) =  multi_vmap f (alpha, xi)
             in Variables.Base.Construction(c, beta, ypsilon)
             end
      |   vmap f (Variables.Base.Variable x)
         =  let
               val new_var =  (X.VarMap.apply (X.DoubleVariableStructure.Map.Pair.snd f)) x
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
      and multi_vmap f (alpha, xi) =   (
                (X.LiteralsConstruction.Qualifier.Multi.vmap (X.DoubleVariableStructure.Map.Pair.fst f) alpha)
             ,  X.PointeredFunctor.map
                      (X.BaseMap.get_map(vmap f))
                      xi )
      val single_vmap =  vmap

      fun get_occurences (X.LiteralsConstruction.Variables.Base.Construction(c, alpha, xi)) =  multi_get_occurences (alpha, xi)
      |   get_occurences (X.LiteralsConstruction.Variables.Base.Variable x) =  X.Occ.singleton(x)
      and multi_get_occurences (alpha, xi)
         =  X.PointeredTypeGenerating.PointeredTypeExtended.transition
              (  fn (t, occ) => Option.SOME (X.Occ.unif_occurences (get_occurences t, occ)))
              xi
              X.Occ.empty

      val select =  PointeredTypeExtended.select
      val is_in  =  PointeredTypeExtended.is_in

      val transition =  PointeredTypeExtended.transition

      structure VSingle =
         struct
            structure Variables =  Variables
            type T =  Variables.Base.Construction
            val eq =  eq
            val equate =  equate
            val get_occurences =  get_occurences
            val vmap =  vmap
         end
      structure Single =
         struct
            structure Variables =  Variables
            type T =  PointeredTypeExtended.BaseType.T
            val eq =  PointeredTypeExtended.BaseType.eq
            fun equate(ik, il)
               =   PointeredTypeExtended.BaseType.traverse (
                         (fn x => PointeredTypeExtended.BaseType.traverse (
                               (fn a => X.LiteralsConstruction.Qualifier.Single.equate(x, a))
                            ,  (fn b => false) )
                            il )
                      ,  (fn y => PointeredTypeExtended.BaseType.traverse (
                               (fn a => false)
                            ,  (fn b => single_equate(y, b)) )
                            il ))
                      ik
            exception NoOcc
            val get_occurences
               =   PointeredTypeExtended.BaseType.traverse (
                         (fn x => raise NoOcc)
                      ,  (fn y => get_occurences y) )
            fun vmap f
               =   PointeredTypeExtended.BaseType.traverse (
                         (PointeredTypeExtended.BaseType.fst_inj o (X.LiteralsConstruction.Qualifier.Single.vmap (X.DoubleVariableStructure.Map.Pair.fst f)))
                      ,  (PointeredTypeExtended.BaseType.snd_inj o (single_vmap f)) )
         end
      structure Multi =
         struct
            structure Variables =  Variables
            type T =  PointeredTypeExtended.ContainerType.T
            local
               fun tf c =  (PointeredTypeExtended.ContainerType.fst c, PointeredTypeExtended.ContainerType.snd c)
            in fun eq (a, b) =  multi_eq (tf a, tf b)
               fun equate (a, b) =  multi_equate (tf a, tf b)
               val get_occurences =  multi_get_occurences o tf
               fun vmap f =  PointeredTypeExtended.ContainerType.tuple o (multi_vmap f) o tf
            end
            val empty =  PointeredTypeExtended.empty
            val is_empty =  PointeredTypeExtended.is_empty
            val subeq =  PointeredTypeExtended.subeq
         end

      structure PointerType =  PointeredTypeExtended.PointerType

   end;
