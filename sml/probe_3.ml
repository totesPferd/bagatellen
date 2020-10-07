use "probe_2.5.ml";

structure MyPELLiteralsConstruction =  LiteralsConstruction (
   struct
      structure C =  PELConstructors;
      structure PCT =  NamingPolymorphicContainerType;
      structure PV =  PolymorphicVariables;
   end );

structure MyPEL =  MyPEL(MyPELLiteralsConstruction);

structure MyPELLiterals =  Literals(
   struct
      structure BaseMap =  MyPEL.MyPELLiteralsMap
      structure VarMap =  MyPEL.MyPELVariablesMap
      structure VariableStructure =  MyPEL.MyPELVariablesStructure
      structure Occ =  MyPEL.MyPELOccurences
      structure LiteralsConstruction =  MyPELLiteralsConstruction
      structure PointeredTypeGenerating =  MyPEL.MyPELLiteralsPointeredTypeGenerating
      structure PointeredFunctor =  MyPEL.MyPELLiteralsPointeredFunctor
      structure AllZip =  MyPEL.MyPELLiteralsPointeredTypeGenerating.AllZip
   end );

structure MyPELContecteds =  Contecteds(
   struct
      structure Lit =  MyPELLiterals
      structure VarCtxt =  MyPEL.MyPELVariableContexts
   end );

structure MyPELProof =  Proof(
   struct
      structure Contecteds =  MyPELContecteds
      structure PointeredBaseMap =  MyPEL.MyPELLiteralsPointeredMap
      structure PointerType =  PointeredBaseMap.PointerType
      structure PointeredGeneration =  MyPEL.MyPELLiteralsPointeredGeneration
      structure PointeredSingleton =  MyPEL.MyPELLiteralsPointeredSingleton
   end );

