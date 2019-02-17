use "logics/pprint/polymorphic_pprinting.fun";
use "logics/pprint/pprinting.sig";

functor PPrintPPrinting(X: PPrintPPrintable): PPrintPPrinting =
   struct
      structure PPrintPPrintable =  X
      structure PPrintPolymorphicPPrinting =
         PPrintPolymorphicPPrinting(
            struct
               structure ContextType =  X.ContextType
               structure PPrintIndentBase =  X.PPrintIndentBase
            end )
      val pprint =  PPrintPolymorphicPPrinting.pprint PPrintPPrintable.single_line PPrintPPrintable.multi_line
   end;
