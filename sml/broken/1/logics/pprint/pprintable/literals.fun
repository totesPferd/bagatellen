use "collections/naming_pointered_type_generating.sig";
use "logics/construction.sig";
use "logics/literals.sig";
use "logics/pprint/indent_base.sig";
use "logics/pprint/polymorphic_pprinting.sig";
use "logics/pprint/polymorphic_setalikes.sig";
use "logics/pprint/pprintable.sig";
use "logics/pprint/pprintable/literals.sig";
use "logics/variable_contexts.sig";

functor PPrintPPrintableLiterals(X:
   sig
      structure NPT: NamingPointeredTypeGenerating
      structure Constr: LiteralsConstruction
      structure Lit: Literals
         where type Multi.T =  Constr.Variables.Base.Single.T Constr.PolymorphicContainerType.T
      structure VarCtxt: VariableContexts
         where type PointeredTypeExtended.ContainerType.T =  NPT.PointeredTypeExtended.ContainerType.T
         and   type PointeredTypeExtended.PointerType.T =  NPT.PointeredTypeExtended.PointerType.T
      structure PP: PPrintPolymorphicPPrinting
         where type ContextType.T =  VarCtxt.VariableContext.T
      structure PS: PPrintPolymorphicSetalikes
         where type ContextType.T =  VarCtxt.VariableContext.T
      sharing Constr.Constructors = Lit.Constructors
      sharing Constr.Variables = Lit.Variables
      sharing Lit.VariableStructure = VarCtxt.VariableStructure
      sharing NPT.PointeredTypeExtended.BaseStructure = VarCtxt.VariableStructure
      sharing NPT.PointeredTypeExtended.BaseStructureMap = VarCtxt.PointeredTypeExtended.BaseStructureMap
      sharing NPT.PointeredTypeExtended.BaseType = VarCtxt.PointeredTypeExtended.BaseType
      sharing NPT.PointeredTypeExtended.BaseType = Lit.Variables
      sharing PP.PPrintIndentBase = PS.PPrintIndentBase
      sharing Lit.Variables.Base.Single = VarCtxt.VariableStructure.BaseType

      val get_constructors_name: Lit.Constructors.T -> string
   end ): PPrintPPrintableLiterals =
   struct

      structure ContextType =  X.VarCtxt.VariableContext
      structure Literals =  X.Lit
      structure NamingPointeredTypeGenerating =  X.NPT
      structure PPrintIndentBase =  X.PP.PPrintIndentBase
      structure Variables =  Literals.Variables
      structure VariableStructure =  X.VarCtxt.VariableStructure
      structure VariableContexts =  X.VarCtxt

      fun l_single_line ctxt (X.Constr.Variables.Base.Construction(c, xi))
         =  (X.get_constructors_name c) ^ "(" ^ (multi_l_single_line ctxt xi) ^ ")"
      |   l_single_line ctxt (X.Constr.Variables.Base.Variable v)
         =  if X.NPT.PointeredTypeExtended.is_in(v, ctxt)
            then
               Option.valOf (X.NPT.get_name v ctxt)
            else
               l_single_line ctxt (Option.valOf(X.Lit.Variables.get_val v))
      and multi_l_single_line ctxt
         =  X.PS.single_line
               X.Lit.transition
               l_single_line
               ctxt

      fun l_multi_line ctxt ((stream: TextIO.outstream), X.Constr.Variables.Base.Construction(c, xi), (rhs_indent: int)) (indent, state)
         =  let
               val state' =  PPrintIndentBase.print (stream, X.get_constructors_name c) state
               val state'' =  PPrintIndentBase.print_par (stream, "(") state'
               val state''' =  multi_l_multi_line ctxt (stream, xi, rhs_indent - 1) (indent, state'')
               val state'''' =  PPrintIndentBase.print_par (stream, ")") state'''
            in
               state''''
            end
      |   l_multi_line ctxt ((stream: TextIO.outstream), X.Constr.Variables.Base.Variable v, (rhs_indent: int)) (indent, state)
         =  if X.NPT.PointeredTypeExtended.is_in(v, ctxt)
            then
               let
                  val name =  Option.valOf (X.NPT.get_name v ctxt)
                  val state' =  PPrintIndentBase.print (stream, name) state
               in
                  state'
               end
            else
               l_multi_line ctxt (stream, Option.valOf(X.Lit.Variables.get_val v), rhs_indent) (indent, state)
      and l_pprint ctxt
         =  X.PP.pprint
               l_single_line
               l_multi_line
               ctxt
      and multi_l_multi_line ctxt
         =  X.PS.multi_line
               X.Lit.transition
               l_pprint
               ctxt

      structure Single: PPrintPPrintable =
         struct
            structure ContextType =  ContextType
            structure PPrintIndentBase =  PPrintIndentBase
            type T =  X.Lit.Single.T
            fun single_line ctxt =  l_single_line ctxt
            fun multi_line ctxt (stream, mt, rhs_indent)
               =  l_multi_line ctxt (stream, mt, rhs_indent)
         end
      structure Multi: PPrintPPrintable =
         struct
            structure ContextType =  ContextType
            structure PPrintIndentBase =  PPrintIndentBase
            type T =  X.Lit.Multi.T
            fun single_line ctxt =  multi_l_single_line ctxt
            fun multi_line ctxt (stream, mmt, rhs_indent)
               =  multi_l_multi_line ctxt (stream, mmt, rhs_indent)
         end

   end;
