use "probe_3.ml";

structure MyQualifiedLiteralsConstruction =  QualifiedLiteralsConstruction (
   struct
      structure C =  PELConstructors;
      structure Q =  MyQLLiterals;
      structure PCT =  NamingPolymorphicContainerType;
      structure PV =  PolymorphicVariables;
   end );

structure MyQualifiedPEL =  MyPEL(MyQualifiedLiteralsConstruction);

structure MyQualifiedIncludeDictSet =  DictSet(MyQualifiedPEL.MyDblVariablesSum)
structure MyQualifiedIncludeOccurences =  Occurences(MyQualifiedIncludeDictSet)

structure MyQualifiedOccurences =  QualifiedOccurences (
   struct
      structure Include =  MyQualifiedIncludeOccurences;
      structure Qualifier =  MyQLLiterals.Occurences;
      structure QualifiedBaseType =  MyQualifiedPEL.MyDblVariablesSum;
   end );

(*
structure MyQualifiedLiterals =  QualifiedLiterals (
   struct
      structure LiteralsConstruction =  MyQualifiedLiteralsConstruction;
      structure PointeredTypeGenerating =  MyQualifiedPEL.MyPELLiteralsPointeredTypeGenerating;
      structure DoublePointeredTypeExtended =  MyQualifiedPEL.MyDblLiteralsPointeredTypeExtended;
      structure DoubleVariableStructure =  MyQualifiedPEL.MyDblVariablesStructure;
      structure VariableStructure =  MyQualifiedPEL.MyPELVariablesStructure;
      structure BaseMap =  MyQualifiedPEL.MyDblLiteralsMap;
      structure VarMap =  MyQualifiedPEL.MyPELVariablesMap;
      structure PointeredFunctor =  MyQualifiedPEL.MyDblLiteralsPointeredFunctor;
      structure Occ =  MyQualifiedOccurences;
   end );
*)
