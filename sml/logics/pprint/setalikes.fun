use "collections/type.sig";
use "logics/pprint/delim_config.sig";
use "logics/pprint/polymorphic_setalikes.sig";
use "logics/pprint/pprintable.sig";
use "logics/pprint/pprinting.sig";

functor PPrintSetalikes(X:
   sig
      structure X:
         sig
            structure Single: PPrintPPrintable
            structure Multi: Type
            val transition: (Single.T * 'b -> 'b Option.option) -> Multi.T -> 'b -> 'b
         end
      structure PPrintPolymorphicSetalike: PPrintPolymorphicSetalikes
      structure SinglePPrinting: PPrintPPrinting
      sharing SinglePPrinting.PPrintPPrintable =  X.Single
      sharing PPrintPolymorphicSetalike.ContextType =  X.Single.ContextType
      sharing PPrintPolymorphicSetalike.PPrintIndentBase = X.Single.PPrintIndentBase
   end ): PPrintPPrintable =
   struct
      structure ContextType =  X.X.Single.ContextType

      structure PPrintIndentBase =  X.X.Single.PPrintIndentBase
      type T =  X.X.Multi.T

      val single_line =  X.PPrintPolymorphicSetalike.single_line X.X.transition X.X.Single.single_line
      val multi_line =  X.PPrintPolymorphicSetalike.multi_line X.X.transition X.SinglePPrinting.pprint

   end;
