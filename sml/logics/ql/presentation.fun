use "collections/naming_pointered_type_extension.sig";
use "collections/pointered_type_generating.sig";
use "collections/unit_pointered_type_extension.sig";
use "logics/construction.sig";
use "logics/contecteds.sig";
use "logics/literals.sig";
use "logics/proof.sig";
use "logics/ql/constructors.sig";
use "logics/ql/modules.sig";
use "logics/ql/presentation.sig";
use "logics/ql/qualifier.sig";
use "logics/variable_contexts.sig";
use "logics/variables.sig";
use "pointered_types/pointered_singleton.sig";
use "pointered_types/pointered_type_map.sig";

functor Presentation(X:
   sig
      structure PTG: PointeredTypeGenerating
      structure CX: Contecteds
         where type Literals.PointeredTypeExtended.ContainerType.T = PTG.PointeredTypeExtended.ContainerType.T
      structure L: Literals
         where type PointeredTypeExtended.ContainerType.T = PTG.PointeredTypeExtended.ContainerType.T
      structure LC: LiteralsConstruction
      structure M: Modules
      structure NM: NamingPointeredTypeExtension
      structure NQ: NamingPointeredTypeExtension
      structure P: Proof
         where type Contecteds.Clauses.Multi.T = CX.Clauses.Multi.T
         and   type Contecteds.Clauses.Single.T = CX.Clauses.Single.T
         and   type Contecteds.ContectedLiterals.Multi.T = CX.ContectedLiterals.Multi.T
         and   type Contecteds.ContectedLiterals.Single.T = CX.ContectedLiterals.Single.T
         and   type Contecteds.Literals.PointeredTypeExtended.ContainerType.T = PTG.PointeredTypeExtended.ContainerType.T
      structure C: QLConstructors
      structure Q: Qualifier
      structure UV: UnitPointeredTypeExtension
      structure V: Variables
      structure VC: VariableContexts
      structure VCPTM: PointeredTypeMap
      structure VCPS: PointeredSingleton
      structure LPTM: PointeredTypeMap
         where type End.T =  PTG.PointeredTypeExtended.ContainerType.T
      structure LPS: PointeredSingleton
         where type PointeredType.ContainerType.T = PTG.PointeredTypeExtended.ContainerType.T
      structure QPTM: PointeredTypeMap
      structure QPS: PointeredSingleton

      sharing CX.Constructors = C
      sharing CX.Literals.Occurences = L.Occurences
      sharing CX.Literals.PointeredTypeExtended.BaseStructure = L.PointeredTypeExtended.BaseStructure
      sharing CX.Literals.PointeredTypeExtended.BaseStructureMap = L.PointeredTypeExtended.BaseStructureMap
      sharing CX.Literals.PointeredTypeExtended.BaseType = L.PointeredTypeExtended.BaseType
      sharing CX.Literals.PointerType = L.PointerType
      sharing CX.Literals.Single = L.Single
      sharing CX.Literals.Variables = V
      sharing CX.Literals.VariableStructure = L.VariableStructure
      sharing CX.VariableContexts = VC
      sharing L.Constructors = C
      sharing L.PointeredTypeExtended.BaseStructure = PTG.PointeredTypeExtended.BaseStructure
      sharing L.PointeredTypeExtended.BaseStructureMap = PTG.PointeredTypeExtended.BaseStructureMap
      sharing L.PointeredTypeExtended.BaseType = PTG.PointeredTypeExtended.BaseType
      sharing L.PointeredTypeExtended.PointerType = PTG.PointeredTypeExtended.PointerType
      sharing L.Variables = V
      sharing L.VariableStructure.BaseType = V.Base
      sharing LC.Constructors = C
      sharing LC.PolymorphicContainerType = PTG.PolymorphicContainerType
      sharing LC.Variables = V
      sharing NM.PointeredTypeExtended.BaseType = M
      sharing NQ.PointeredTypeExtended.BaseType = Q
      sharing C.Modules = M
      sharing P.Constructors = C
      sharing P.Contecteds.Literals.Occurences = L.Occurences
      sharing P.Contecteds.Literals.PointeredTypeExtended.BaseStructure = L.PointeredTypeExtended.BaseStructure
      sharing P.Contecteds.Literals.PointeredTypeExtended.BaseStructureMap = L.PointeredTypeExtended.BaseStructureMap
      sharing P.Contecteds.Literals.PointeredTypeExtended.BaseType = L.PointeredTypeExtended.BaseType
      sharing P.Contecteds.Literals.PointerType = L.PointerType
      sharing P.Contecteds.Literals.Single = L.Single
      sharing P.Contecteds.Literals.Variables = V
      sharing P.Contecteds.Literals.VariableStructure = L.VariableStructure
      sharing P.Contecteds.VariableContexts = VC
      sharing C.Qualifier = Q
      sharing VC.PointeredTypeExtended = UV.PointeredTypeExtended
      sharing VC.PointeredTypeExtended.BaseType = V
      sharing VCPS.PointeredType =  VC.PointeredTypeExtended
      sharing VCPTM.Start =  VCPS.PointeredType.BaseType
      sharing VCPTM.End =  VCPS.PointeredType.ContainerType
      sharing VCPTM.PointerType =  VCPS.PointerType
      sharing VCPTM.Map =  VCPS.PointeredMap.Map
      sharing LPS.PointeredType.BaseStructure = L.PointeredTypeExtended.BaseStructure
      sharing LPS.PointeredType.BaseStructureMap = L.PointeredTypeExtended.BaseStructureMap
      sharing LPS.PointeredType.BaseType = L.PointeredTypeExtended.BaseType
      sharing LPS.PointeredType.PointerType = L.PointeredTypeExtended.PointerType
      sharing LPTM.Start =  LPS.PointeredType.BaseType
      sharing LPTM.PointerType =  LPS.PointerType
      sharing LPTM.Map =  LPS.PointeredMap.Map
      sharing QPS.PointeredType =  NQ.PointeredTypeExtended
      sharing QPTM.Start =  QPS.PointeredType.BaseType
      sharing QPTM.End =  QPS.PointeredType.ContainerType
      sharing QPTM.PointerType =  QPS.PointerType
      sharing QPTM.Map =  QPS.PointeredMap.Map

   end ): Presentation =
   struct
      structure Contecteds =  X.CX
      structure Literals =  X.L
      structure Modules =  X.M
      structure Proof =  X.P
      structure QLConstructors =  X.C
      structure Qualifier =  X.Q
      structure VariableContexts =  X.VC

      structure ModulesBag =  X.NM
      structure QualifierBag =  X.NQ

      structure QualifierPointer =  QualifierBag.StringType

      type state =  {
            equations: Proof.Multi.T
         ,  modules: ModulesBag.PointeredTypeExtended.ContainerType.T
         ,  qualifier: QualifierBag.PointeredTypeExtended.ContainerType.T
         ,  typecheck_info: Proof.Multi.T }

      fun get_typecheck_clause (pointer_1, pointer_2, pointer_3) (state: state) (lit: Contecteds.ContectedLiterals.Single.T, d0: string, d1: string)
        = case (ModulesBag.PointeredTypeExtended.select(ModulesBag.StringType.point d0, (#modules state))) of
             Option.NONE => Option.NONE
          |  Option.SOME md0
             => case (ModulesBag.PointeredTypeExtended.select(ModulesBag.StringType.point d1, (#modules state))) of
                Option.NONE => Option.NONE
             |  Option.SOME md1
                => let
                      val (var_ctxt: X.VC.VariableContext.T) =  Contecteds.ContectedLiterals.Single.get_context lit
                   in
                      case (X.VC.PointeredTypeExtended.select(X.UV.UnitType.point, var_ctxt)) of
                         Option.NONE => Option.NONE
                      |  Option.SOME lit_var
                         => let
                               val lit_conclusion =  Contecteds.ContectedLiterals.Single.get_conclusion lit
                               val new_conclusion
                                  =  X.LC.Variables.Base.Construction(
                                        QLConstructors.module md1
                                     ,  X.LPTM.apply X.LPS.singleton (pointer_1, lit_conclusion) )
                               val premis
                                  =  X.LC.Variables.Base.Construction(
                                        QLConstructors.module md0
                                     ,  X.LPTM.apply X.LPS.singleton (pointer_2, X.LC.Variables.Base.Variable lit_var))
                               val new_antecedent
                                  =  X.LPTM.apply X.LPS.singleton (pointer_3, premis)
                            in
                               Option.SOME (Contecteds.Clauses.Single.construct (var_ctxt, new_antecedent, new_conclusion))
                            end
                   end

      fun typecheck (pointer_1, pointer_2, pointer_3, pointer_4) (state: state) data
        = let
             val (clo: Contecteds.Clauses.Single.T Option.option) =  get_typecheck_clause (pointer_1, pointer_2, pointer_3) state data
          in
             Option.map (Proof.apply_conventionally pointer_4 (#typecheck_info state)) clo
          end

      fun add_module str (state: state)
        = let
             val module =  Modules.new()
             val new_bag =  ModulesBag.adjoin (str, module, (#modules state))
          in
             {
                equations = #equations state
             ,  modules = new_bag
             ,  qualifier = #qualifier state
             ,  typecheck_info = #typecheck_info state }: state 
          end

      exception ParanormalEffectHasOccured
      fun add_qualifier (pointer_1, pointer_2, pointer_3, pointer_4) (str: string, d0: string, d1: string) (state: state)
        = let
             val qual =  Qualifier.new()
             val new_bag =  QualifierBag.adjoin (str, qual, (#qualifier state))
             val new_var =  X.V.new
             val new_var_ctxt =  X.VCPTM.apply X.VCPS.singleton (X.UV.UnitType.point, new_var)
             val qual_lit
                =  X.LC.Variables.Base.Construction(
                      QLConstructors.qualifier qual
                   ,  X.LPTM.apply X.LPS.singleton (pointer_4, X.LC.Variables.Base.Variable new_var))
             val ctxt_qual_lit =  Contecteds.ContectedLiterals.Single.construct(new_var_ctxt, qual_lit)
             val (clo: Contecteds.Clauses.Single.T Option.option) =  get_typecheck_clause (pointer_1, pointer_2, pointer_3) state (ctxt_qual_lit, d0, d1)
             val new_tc_info =  Option.map (fn cl => Proof.add_clause_to_proof (cl, #typecheck_info state)) clo
          in
             case (new_tc_info) of
                Option.NONE =>  raise ParanormalEffectHasOccured
             |  Option.SOME nti
                => {
                      equations = #equations state
                   ,  modules = #modules state
                   ,  qualifier = new_bag
                   ,  typecheck_info = nti }: state
          end

      fun add_equation (pointer_1, pointer_2, q_pointer) (var_ctxt: VariableContexts.VariableContext.T, lit_1: Literals.Single.T, lit_2: Literals.Single.T) (state: state)
        = let
             val qual_vars =
                case (X.VC.PointeredTypeExtended.select(X.UV.UnitType.point, var_ctxt)) of
                   Option.NONE => Literals.Multi.empty
                |  Option.SOME var => X.LPTM.apply X.LPS.singleton (pointer_1, X.LC.Variables.Base.Variable var)
             val qual =  Qualifier.new()
             val new_qual_bag
               =  QualifierBag.sum (
                     X.QPTM.apply X.QPS.singleton (q_pointer, qual)
                  ,  #qualifier state )
             val qual_lit =  X.LC.Variables.Base.Construction(QLConstructors.qualifier qual, qual_vars)
             val antecedent =  X.LPTM.apply X.LPS.singleton (pointer_2, qual_lit)
             val cl_1 =  Contecteds.Clauses.Single.construct(var_ctxt, antecedent, lit_1)
             val cl_2 =  Contecteds.Clauses.Single.construct(var_ctxt, antecedent, lit_2)
             val new_eq_bag
               = Proof.add_clause_to_proof (cl_1, Proof.add_clause_to_proof(cl_2, #equations state))
          in
             {
                equations =  new_eq_bag
             ,  modules = #modules state
             ,  qualifier = new_qual_bag
             ,  typecheck_info = #typecheck_info state }: state
          end

      fun get_normalform pointer (state: state) (lit: Contecteds.ContectedLiterals.Single.T)
        = let
             val (cl: Contecteds.Clauses.Single.T) =  Contecteds.make_clause_from_conclusion lit
             val (result: Contecteds.Clauses.Multi.T) =  Proof.apply pointer (#equations state) cl
          in
             result: Contecteds.Clauses.Multi.T
          end

      fun ceq pointer (state: state) (var_ctxt: VariableContexts.VariableContext.T, lit_1: Literals.Single.T, lit_2: Literals.Single.T)
        = let
             val ctxt_lit_1 =  Contecteds.ContectedLiterals.Single.construct(var_ctxt, lit_1)
             val nf_1 =  get_normalform pointer state ctxt_lit_1
             val ctxt_lit_2 =  Contecteds.ContectedLiterals.Single.construct(var_ctxt, lit_2)
             val nf_2 =  get_normalform pointer state ctxt_lit_2
          in
             Contecteds.Clauses.Multi.eq(nf_1, nf_2)
          end

      fun seqset (clit_1: Contecteds.ContectedLiterals.Single.T, clit_2: Contecteds.ContectedLiterals.Single.T)
        = let
             val var_ctxt_2 =  Contecteds.ContectedLiterals.Single.get_context clit_2
          in
             case (X.VC.PointeredTypeExtended.select(X.UV.UnitType.point, var_ctxt_2)) of
                Option.NONE => Option.NONE
             |  Option.SOME var =>
                 let
                    val var_ctxt_1 =  Contecteds.ContectedLiterals.Single.get_context clit_1
                    val lit_1 =  Contecteds.ContectedLiterals.Single.get_conclusion clit_1
                    val lit_2 =  Contecteds.ContectedLiterals.Single.get_conclusion clit_2
                    val var_lit_2 =  X.LC.Variables.Base.Variable var
                    val _ =  Literals.Single.equate(var_lit_2, lit_1)
                 in
                    Option.SOME (Contecteds.ContectedLiterals.Single.construct(var_ctxt_1,  lit_2))
                 end
          end

      fun get_constructors_name (state: state)
         = let
              fun mod_resolve m
                 =  ":" ^ Option.valOf (ModulesBag.get_name m (#modules state))

              fun qual_resolve q
                 =  "[" ^ Option.valOf (QualifierBag.get_name q (#qualifier state)) ^ "]"

           in QLConstructors.traverse (mod_resolve, qual_resolve)
           end
   end;
