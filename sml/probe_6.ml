use "probe_5.ml";

(*
structure MyQLPresentation =  Presentation (
   struct
      structure PTG =  MyQLLiteralsPointeredTypeGenerating
      structure CX =  MyQLContecteds
      structure L =  MyQLLiterals
      structure LC =  MyQLLiteralsConstruction
      structure M =  Modules
      structure NM =
      structure NO =
      structure P =  MyQLProof
      structure C =  MyQLConstructors
      structure Q =  Qualifier
      structure UV =
      structure V =  MyQLLiteralsConstruction.Variables
      structure VC =  MyQLVariableContexts
      structure VCPTM =
      structure VCPS =  MyQLVariablesPointeredSingleton
      structure LPTM =
      structure LPS =  MyQLLiteralsPointeredSingleton
      structure OPTM =
      structure OPS =
   end );
*)

structure MyPPrintConfig: PPrintConfig =
   struct
      type config = {indent: int, page_width: int}
      val config =  { indent = 3, page_width = 72 }
   end;

structure MyPPrintBase: PPrintBase =  PPrintBase(MyPPrintConfig);

structure MyPPrintIndentBase: PPrintIndentBase =  PPrintIndentBase (
   struct
      structure B = MyPPrintBase
      structure C = MyPPrintConfig
   end );

structure MyQLPPrintPolymorphicPPrinting: PPrintPolymorphicPPrinting =  PPrintPolymorphicPPrinting (
   struct
      structure ContextType =  MyQLVariableContexts.VariableContext
      structure PPrintIndentBase =  MyPPrintIndentBase
   end );

structure MyPELPPrintPolymorphicPPrinting: PPrintPolymorphicPPrinting =  PPrintPolymorphicPPrinting (
   struct
      structure ContextType =  MyPEL.MyPELVariableContexts.VariableContext
      structure PPrintIndentBase =  MyPPrintIndentBase
   end );

structure MyDblPPrintPolymorphicPPrinting: PPrintPolymorphicPPrinting =  PPrintPolymorphicPPrinting (
   struct
      structure ContextType =  MyQualifiedPEL.MyPELVariableContexts.VariableContext
      structure PPrintIndentBase =  MyPPrintIndentBase
   end );

(*
structure MyDblPPrintPolymorphicSetalike: PPrintPolymorphicSetalikes =  PPrintSetalikes (
   struct
      structure ContextType =  MyQualifiedPEL.MyPELVariableContexts.VariableContext
      structure DelimConfig =  PPrintCommaDelim
      structure PPrintIndentBase =  MyPPrintIndentBase
   end );

structure MyQLPPrintableLiterals =  PPrintableLiterals (
   struct
      structure NPT =
      structure Constr =  MyQLLiteralsConstruction
      structure Lit =  MyQLLiterals
      structure VarCtxt =  MyQLVariableContexts
      structure PP =  MyQLPPrintPolymorphicPPrinting
      structure PS =  MyQLPPrintPolymorphicSetalike
   end );
*)
