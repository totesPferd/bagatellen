use "collections/naming_pointered_type_extension.sig";
use "logics/literals.sig";
use "logics/pprint/indent_base.sig";
use "logics/pprint/polymorphic_pprinting.sig";
use "logics/pprint/polymorphic_setalikes.sig";
use "logics/pprint/pprintable.sig";
use "logics/pprint/pprintable/literals.sig";
use "logics/variable_contexts.sig";

functor PPrintPPrintableLiterals(X:
   sig
      structure Lit: Literals
      structure NPT: NamingPointeredTypeExtension
      structure VarCtxt: VariableContexts
      structure PP: PPrintPolymorphicPPrinting
      structure PS: PPrintPolymorphicSetalikes
      sharing Lit.Variables = VarCtxt.Variables
      sharing NPT.PointeredType2.BaseType = VarCtxt.Variables
      sharing NPT.PointeredType2 = VarCtxt.PointeredType2
      sharing PP.ContextType = PS.ContextType
      sharing PP.ContextType = VarCtxt.VariableContext
      sharing PP.PPrintIndentBase = PS.PPrintIndentBase

      val get_constructors_name: Lit.Constructors.T -> string
   end ): PPrintPPrintableLiterals =
   struct

      structure ContextType =  X.VarCtxt.VariableContext
      structure Literals =  X.Lit
      structure NamingPointeredTypeExtension =  X.NPT
      structure PPrintIndentBase =  X.PP.PPrintIndentBase
      structure Variables =  Literals.Variables
      structure VariableContexts =  X.VarCtxt

      datatype Construction =  Construction of X.Lit.Constructors.T * (Construction list) | Variable of string * X.Lit.Variables.T

      fun reconstruct (ctxt: ContextType.T)
         =  X.Lit.Single.traverse(
                  (Construction: X.Lit.Constructors.T * (Construction list) -> Construction)
               ,  (  fn (v: X.Lit.Variables.T)
                     => if X.NPT.PointeredType2.is_in(v, ctxt)
                        then
                           Variable (Option.valOf (X.NPT.get_name v ctxt), v)
                        else
                           reconstruct ctxt (Option.valOf(X.Lit.Variables.get_val v)) )
               ,  ((Option.SOME o op::): Construction * Construction list -> (Construction list) Option.option)
               ,  (nil: Construction list) )
      fun multi_reconstruct ctxt m
         =  X.Lit.transition
               (  fn (x, l) => Option.SOME ((reconstruct ctxt x) :: l) )
               m
               nil

      fun transition phi nil b = b
      |   transition phi (x::l) b
         =  case (phi(x, b)) of
               Option.NONE => b
            |  Option.SOME b' => (transition phi l b')

      fun l_single_line ctxt (Construction(c, xi))
         =  (X.get_constructors_name c) ^ "(" ^ (multi_l_single_line ctxt xi) ^ ")"
      |   l_single_line ctxt (Variable (name, v))
         =  name
      and multi_l_single_line ctxt
         =  X.PS.single_line
               transition
               l_single_line
               ctxt

      fun l_multi_line ctxt ((stream: TextIO.outstream), Construction(c, xi), (rhs_indent: int)) (indent, state)
         =  let
               val state' =  PPrintIndentBase.print (stream, X.get_constructors_name c) state
               val state'' =  PPrintIndentBase.print_par (stream, "(") state'
               val state''' =  multi_l_multi_line ctxt (stream, xi, rhs_indent - 1) (indent, state'')
               val state'''' =  PPrintIndentBase.print_par (stream, ")") state'''
            in
               state''''
            end
      |   l_multi_line ctxt ((stream: TextIO.outstream), Variable(name, v), (rhs_indent: int)) (indent, state)
         =  let
               val state' =  PPrintIndentBase.print (stream, name) state
            in
               state'
            end
      and l_pprint ctxt
         =  X.PP.pprint
               l_single_line
               l_multi_line
               ctxt
      and multi_l_multi_line ctxt
         =  X.PS.multi_line
               transition
               l_pprint
               ctxt

      structure Single: PPrintPPrintable =
         struct
            structure ContextType =  ContextType
            structure PPrintIndentBase =  PPrintIndentBase
            type T =  X.Lit.Single.T
            fun single_line ctxt =  (l_single_line ctxt) o (reconstruct ctxt)
            fun multi_line ctxt (stream, mt, rhs_indent)
               =  l_multi_line ctxt (stream, (reconstruct ctxt mt), rhs_indent)
         end
      structure Multi: PPrintPPrintable =
         struct
            structure ContextType =  ContextType
            structure PPrintIndentBase =  PPrintIndentBase
            type T =  X.Lit.Multi.T
            fun single_line ctxt =  (multi_l_single_line ctxt) o (multi_reconstruct ctxt)
            fun multi_line ctxt (stream, mmt, rhs_indent)
               =  multi_l_multi_line ctxt (stream, (multi_reconstruct ctxt mmt), rhs_indent)
         end

   end;
