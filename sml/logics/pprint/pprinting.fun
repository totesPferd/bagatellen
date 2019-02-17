use "logics/pprint/polymorphic_pprinting.sig";
use "logics/pprint/pprinting.sig";

functor PPrintPPrinting(X:
   sig
      structure PPrintPPrintable: PPrintPPrintable
      structure PPrintPolymorphicPPrinting: PPrintPolymorphicPPrinting
      sharing PPrintPolymorphicPPrinting.ContextType = PPrintPPrintable.ContextType
      sharing PPrintPolymorphicPPrinting.PPrintIndentBase =  PPrintPPrintable.PPrintIndentBase
   end ): PPrintPPrinting =
   struct
      structure PPrintPPrintable =  X.PPrintPPrintable
      structure PPrintPolymorphicPPrinting =  X.PPrintPolymorphicPPrinting
      val pprint =  PPrintPolymorphicPPrinting.pprint PPrintPPrintable.single_line PPrintPPrintable.multi_line
   end;
