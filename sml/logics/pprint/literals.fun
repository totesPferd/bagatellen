use "collections/naming_pointered_type.sig";
use "logics/literals.sig";
use "logics/pprint/indent_base.sig";
use "logics/pprint/polymorphic_pprinting.sig";
use "logics/pprint/polymorphic_setalikes.sig";
use "logics/variable_contexts.sig";

functor PPrintLiterals(X:
   sig
      structure Lit: Literals
      structure NPT: NamingPointeredType
      structure VarCtxt: VariableContexts
      structure PP: PPrintPolymorphicPPrinting
      structure PS: PPrintPolymorphicSetalikes
      sharing Lit.Variables = VarCtxt.Variables
      sharing NPT.PointeredType.BaseType = VarCtxt.Variables
      sharing VarCtxt.PointeredType =  NPT.PointeredType
      sharing PP.ContextType = PS.ContextType
      sharing PP.PPrintIndentBase = PS.PPrintIndentBase
   end ) =
   struct

      structure ContextType =  X.VarCtxt.VariableContext
      structure PPrintIndentBase =  X.PP.PPrintIndentBase

      datatype Construction =  Construction of X.Lit.Constructors.T * (Construction list) | Variable of string * X.Lit.Variables.T

      fun reconstruct (ctxt: ContextType.T)
         =  X.Lit.Single.traverse(
                  (Construction: X.Lit.Constructors.T * (Construction list) -> Construction)
               ,  (  fn (v: X.Lit.Variables.T)
                     => if X.NPT.PointeredType.is_in(v, ctxt)
                        then
                           Variable (Option.valOf (X.NPT.get_name v ctxt), v)
                        else
                           reconstruct ctxt (Option.valOf(X.Lit.Variables.get_val v)) )
               ,  ((Option.SOME o op::): Construction * Construction list -> (Construction list) Option.option)
               ,  (nil: Construction list) )

      structure Single =
         struct
            structure ContextType =  ContextType
            structure PPrintIndentBase =  PPrintIndentBase
            type T =  X.Lit.Single.T
         end
      structure Multi =
         struct
            structure ContextType =  ContextType
            structure PPrintIndentBase =  PPrintIndentBase
            type T =  X.Lit.Multi.T
         end

   end;
