use "logics/pprint/pprinting.sig";
use "logics/pprint/pprintable/literals.sig";

functor PPrintContext(X:
   sig
      structure PPrintPPrintableLiterals: PPrintPPrintableLiterals
      structure PPrintPPrinting: PPrintPPrinting
         where type PPrintPPrintable.T =  PPrintPPrintableLiterals.Single.T
         and   type PPrintPPrintable.ContextType.T =  PPrintPPrintableLiterals.Single.ContextType.T
      sharing PPrintPPrinting.PPrintPPrintable.PPrintIndentBase =  PPrintPPrintableLiterals.Single.PPrintIndentBase
      sharing PPrintPPrintableLiterals.NamingPointeredTypeGenerating.PointeredTypeExtended.BaseType = PPrintPPrintableLiterals.Literals.Variables.Base.Single
      sharing PPrintPPrintableLiterals.Literals.Variables.Base.Single = PPrintPPrintableLiterals.Literals.VariableStructure.BaseType
      sharing PPrintPPrintableLiterals.NamingPointeredTypeGenerating.PointeredTypeExtended.BaseType = PPrintPPrintableLiterals.Literals.Variables
   end ) =
   struct

      structure PPrintPPrintableLiterals =  X.PPrintPPrintableLiterals
      structure ContextType =  PPrintPPrintableLiterals.ContextType
      structure Literals =  PPrintPPrintableLiterals.Literals
      structure NamingPointeredTypeGenerating =  PPrintPPrintableLiterals.NamingPointeredTypeGenerating
      structure PPrintIndentBase =  PPrintPPrintableLiterals.PPrintIndentBase
      structure Variables =  Literals.Variables

      fun multi_line (ctxt: ContextType.T) stream (indent, state)
         =  NamingPointeredTypeGenerating.transition
               (  fn (pn, v, state_1)
                     =>  case (pn) of
                            Option.NONE => Option.SOME state_1
                         |  Option.SOME name
                            => case (Variables.get_val v) of
                                  Option.NONE => Option.SOME state_1
                               |  Option.SOME value
                                  => let
                                        val state_2 =  PPrintIndentBase.navigate_to_pos (stream, 0) (indent, state_1)
                                        val state_3 =  PPrintIndentBase.print (stream, name) state_2
                                        val state_4 =  PPrintIndentBase.print (stream, ":= ") state_3
                                        val state_5 =  X.PPrintPPrinting.pprint ctxt (stream, value, 0) (indent, state_4)
                                     in
                                        Option.SOME state_5
                                     end )
               ctxt
               state
   end;
