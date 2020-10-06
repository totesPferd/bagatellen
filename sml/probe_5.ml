use "probe_4.ml";

structure MyQualifiedLiteralsConstruction =  QualifiedLiteralsConstruction (
   struct
      structure C =  PELConstructors;
      structure Q =  MyQLLiterals;
      structure PCT =  NamingPolymorphicContainerType;
      structure PV =  PolymorphicVariables;
   end );

structure MyQualifiedIncludeDictSet =  DictSet(MyDblVariablesSum)
structure MyQualifiedIncludeOccurences =  Occurences(MyQualifiedIncludeDictSet)

structure MyQualifiedOccurences =  QualifiedOccurences (
   struct
      structure Include =  MyQualifiedIncludeOccurences;
      structure Qualifier =  MyQLLiterals.Occurences;
      structure QualifiedBaseType =  MyDblVariablesSum;
   end );

(*
structure MyQualifiedLiterals =  QualifiedLiterals (
   struct
      structure LiteralsConstruction =  MyQualifiedLiteralsConstruction;
      structure PointeredTypeGenerating =  MyPELLiteralsPointeredTypeGenerating;
      structure DoublePointeredTypeExtended =  MyDblLiteralsPointeredTypeExtended;
      structure DoubleVariableStructure =  MyDblVariablesStructure;
      structure VariableStructure =  MyPELVariablesStructure;
      structure BaseMap =  MyDblLiteralsPointeredFunctor.Map;
      structure VarMap =  MyPELVariablesStructure.Map;
      structure PointeredFunctor =  MyDblLiteralsPointeredFunctor;
      structure Occ =  MyQualifiedOccurences;
   end );
*)
