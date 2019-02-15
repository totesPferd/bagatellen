use "logics/pprint/pprintable.sig";
use "logics/pprint/pprinting.sig";

functor PPrintPPrinting(X: PPrintPPrintable): PPrintPPrinting =
   struct
      structure PPrintPPrintable =  X
      fun pprint (stream, t, rhs_indent) (indent, state)
         = let
              val check_single_line =  PPrintPPrintable.single_line(t)
              val real_width =  PPrintPPrintable.PPrintIndentBase.get_rel_width(indent) - rhs_indent
           in if String.size(check_single_line) + 1 > real_width
              then
                 PPrintPPrintable.multi_line (stream, t, rhs_indent) (indent, state)
              else
                 let
                    val state' =  PPrintPPrintable.PPrintIndentBase.print (stream, check_single_line) state
                    val state'' =  PPrintPPrintable.PPrintIndentBase.force_ws state'
                 in state''
                 end
           end
   end;
