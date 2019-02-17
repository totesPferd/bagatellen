use "collections/naming_pointered_type.sig";
use "logics/literals.sig";
use "logics/pprint/indent_base.sig";
use "logics/variable_contexts.sig";

functor PPrintLiterals(X:
   sig
      structure CStr:
         sig
            structure PIB: PPrintIndentBase
            structure Lit: Literals
            val r_single_line: Lit.Constructors.T * string -> string
            val r_multiple_line: TextIO.outstream * int -> PIB.indent * PIB.state -> Lit.Single.T Option.option * PIB.state -> PIB.state
         end
      structure NPT: NamingPointeredType
      structure VarCtxt: VariableContexts
      sharing CStr.Lit.Variables = VarCtxt.Variables
      sharing NPT.PointeredType.BaseType = VarCtxt.Variables
      sharing VarCtxt.PointeredType =  NPT.PointeredType
   end ) =
   struct
      structure ContextType =  X.VarCtxt.VariableContext
      structure PPrintIdentBase =  X.CStr.PIB


   end;
