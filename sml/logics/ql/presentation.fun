use "collections/naming_pointered_type.sig";
use "collections/unit_pointered_type.sig";
use "logics/contecteds.sig";
use "logics/literals.sig";
use "logics/proof.sig";
use "logics/ql/constructors.sig";
use "logics/ql/modules.sig";
use "logics/ql/presentation.sig";
use "logics/ql/qualifier.sig";
use "logics/variable_contexts.sig";
use "logics/variables.sig";

functor Presentation(X:
   sig
      structure CX: Contecteds
      structure L: Literals
      structure M: Modules
      structure NM: NamingPointeredType
      structure NQ: NamingPointeredType
      structure P: Proof
      structure C: QLConstructors
      structure Q: Qualifier
      structure UL: UnitPointeredType
      structure UV: UnitPointeredType
      structure V: Variables
      structure VC: VariableContexts

      sharing CX.Constructors = C
      sharing CX.Literals = L
      sharing CX.VariableContexts = VC
      sharing L.Constructors = C
      sharing L.PointeredType = UL.PointeredType
      sharing L.Variables = V
      sharing NM.PointeredType.BaseType = M
      sharing NQ.PointeredType.BaseType = Q
      sharing C.Modules = M
      sharing P.Constructors = C
      sharing P.Contecteds =  CX
      sharing C.Qualifier = Q
      sharing VC.PointeredType = UV.PointeredType
      sharing VC.Variables = V

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

      type state =  {
            equations: Proof.Multi.T
         ,  modules: ModulesBag.PointeredType.ContainerType.T
         ,  qualifier: QualifierBag.PointeredType.ContainerType.T
         ,  typecheck_info: Proof.Multi.T }

      fun get_typecheck_clause (state: state) (lit: Contecteds.ContectedLiterals.Single.T, d0: string, d1: string)
        = case (ModulesBag.PointeredType.select(ModulesBag.StringType.point d0, (#modules state))) of
             Option.NONE => Option.NONE
          |  Option.SOME md0
             => case (ModulesBag.PointeredType.select(ModulesBag.StringType.point d1, (#modules state))) of
                Option.NONE => Option.NONE
             |  Option.SOME md1
                => let
                      val (var_ctxt: X.VC.VariableContext.T) =  Contecteds.ContectedLiterals.Single.get_context lit
                   in
                      case (X.VC.PointeredType.select(X.UV.UnitType.point, var_ctxt)) of
                         Option.NONE => Option.NONE
                      |  Option.SOME lit_var
                         => let
                               val lit_conclusion =  Contecteds.ContectedLiterals.Single.get_conclusion lit
                               val new_conclusion =  Literals.construct(QLConstructors.module md1, Literals.fe lit_conclusion)
                               val premis =  Literals.construct(QLConstructors.module md0, Literals.fe (Literals.Single.variable lit_var))
                               val new_antecedent =  Literals.fe premis
                            in
                               Option.SOME (Contecteds.Clauses.Single.construct (var_ctxt, new_antecedent, new_conclusion))
                            end
                   end

      fun typecheck (state: state) data
        = let
             val (clo: Contecteds.Clauses.Single.T Option.option) =  get_typecheck_clause state data
          in
             Option.map (Proof.apply_conventionally (#typecheck_info state)) clo
          end

      fun add_module str (state: state)
        = let
             val module =  Modules.new()
             val new_bag =  ModulesBag.adjoin (str, module) (#modules state)
          in
             {
                equations = #equations state
             ,  modules = new_bag
             ,  qualifier = #qualifier state
             ,  typecheck_info = #typecheck_info state }: state 
          end

      fun add_qualifier (str: string, d0: string, d1: string) (state: state)
        = let
             val qual =  Qualifier.new()
             val new_bag =  QualifierBag.adjoin (str, qual) (#qualifier state)
             val new_var =  X.V.new()
             val new_var_ctxt =  X.VC.PointeredType.fe new_var
             val qual_lit =  Literals.construct(QLConstructors.qualifier qual, Literals.fe (Literals.Single.variable new_var))
             val ctxt_qual_lit =  Contecteds.ContectedLiterals.Single.construct(new_var_ctxt, qual_lit)
             val (clo: Contecteds.Clauses.Single.T Option.option) =  get_typecheck_clause state (ctxt_qual_lit, d0, d1)
             val new_tc_info =  Option.map (fn cl => Proof.add_clause_to_proof (cl, #typecheck_info state)) clo
          in
             Option.map
                (fn nti =>
                   {
                      equations = #equations state
                   ,  modules = #modules state
                   ,  qualifier = new_bag
                   ,  typecheck_info = nti }: state )
                new_tc_info
          end

      fun add_equation (var_ctxt: VariableContexts.VariableContext.T, lit_1: Literals.Single.T, lit_2: Literals.Single.T) (state: state)
        = case (X.VC.PointeredType.select(X.UV.UnitType.point, var_ctxt)) of
             Option.NONE => Option.NONE
          |  Option.SOME var =>
             let
                val qual =  Qualifier.new()
                val new_qual_bag =  QualifierBag.sum (QualifierBag.PointeredType.fe qual, #qualifier state)
                val qual_lit =  Literals.construct(QLConstructors.qualifier qual, Literals.fe (Literals.Single.variable var))
                val antecedent =  Literals.fe qual_lit
                val cl_1 =  Contecteds.Clauses.Single.construct(var_ctxt, antecedent, lit_1)
                val cl_2 =  Contecteds.Clauses.Single.construct(var_ctxt, antecedent, lit_2)
                val new_eq_bag
                  = Proof.add_clause_to_proof (cl_1, Proof.add_clause_to_proof(cl_2, #equations state))
             in
                Option.SOME (
                   {
                      equations =  new_eq_bag
                   ,  modules = #modules state
                   ,  qualifier = new_qual_bag
                   ,  typecheck_info = #typecheck_info state }: state )
             end

      fun get_normalform (state: state) (lit: Contecteds.ContectedLiterals.Single.T)
        = let
             val (cl: Contecteds.Clauses.Single.T) =  Contecteds.make_clause_from_conclusion lit
             val (result: Contecteds.Clauses.Multi.T) =  Proof.apply (#equations state) cl
          in
             result: Contecteds.Clauses.Multi.T
          end

      fun ceq (state: state) (var_ctxt: VariableContexts.VariableContext.T, lit_1: Literals.Single.T, lit_2: Literals.Single.T)
        = let
             val ctxt_lit_1 =  Contecteds.ContectedLiterals.Single.construct(var_ctxt, lit_1)
             val nf_1 =  get_normalform state ctxt_lit_1
             val ctxt_lit_2 =  Contecteds.ContectedLiterals.Single.construct(var_ctxt, lit_2)
             val nf_2 =  get_normalform state ctxt_lit_2
          in
             Contecteds.Clauses.Multi.eq(nf_1, nf_2)
          end

      fun seqset (clit_1: Contecteds.ContectedLiterals.Single.T, clit_2: Contecteds.ContectedLiterals.Single.T)
        = let
             val var_ctxt_2 =  Contecteds.ContectedLiterals.Single.get_context clit_2
          in
             case (X.VC.PointeredType.select(X.UV.UnitType.point, var_ctxt_2)) of
                Option.NONE => Option.NONE
             |  Option.SOME var =>
                 let
                    val var_ctxt_1 =  Contecteds.ContectedLiterals.Single.get_context clit_1
                    val lit_1 =  Contecteds.ContectedLiterals.Single.get_conclusion clit_1
                    val lit_2 =  Contecteds.ContectedLiterals.Single.get_conclusion clit_2
                    val var_lit_2 =  Literals.Single.variable var
                    val _ =  Literals.Single.equate(var_lit_2, lit_1)
                 in
                    Option.SOME (Contecteds.ContectedLiterals.Single.construct(var_ctxt_1,  lit_2))
                 end
          end
   end;
