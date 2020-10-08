use "general/type.sig";
use "logics/pprint/indent_base.sig";
use "logics/pprint/polymorphic_pprinting.sig";

functor PPrintPolymorphicPPrinting(X:
   sig
      structure ContextType: Type
      structure PPrintIndentBase: PPrintIndentBase
   end ): PPrintPolymorphicPPrinting =
   struct
      structure ContextType =  X.ContextType
      structure PPrintIndentBase =  X.PPrintIndentBase
      fun pprint (single_line) (multi_line) ctxt (stream, t, rhs_indent) (indent, state)
         = let
              val check_single_line =  single_line ctxt t
              val real_width =  PPrintIndentBase.get_rel_width(indent) - rhs_indent
           in if String.size(check_single_line) + 1 > real_width
              then
                 multi_line ctxt (stream, t, rhs_indent) (indent, state)
              else
                 let
                    val state' =  PPrintIndentBase.print (stream, check_single_line) state
                    val state'' =  PPrintIndentBase.force_ws state'
                 in state''
                 end
           end
   end;
