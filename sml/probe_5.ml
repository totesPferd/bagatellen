use "probe_4.ml";

structure MyQualifiedLiteralsConstruction =  QualifiedLiteralsConstruction (
   struct
      structure C =  PELConstructors;
      structure Q =  MyQLLiterals;
      structure PCT =  NamingPolymorphicContainerType;
      structure PV =  PolymorphicVariables;
   end );

structure MyQualifiedBaseType: SumType =  SumType (
   struct
      structure FstType =  MyQLLiteralsConstruction.Variables;
      structure SndType =  MyPELLiteralsConstruction.Variables;  (* ??? *)
   end );

structure MyQualifiedIncludeDictSet =  DictSet(MyQualifiedBaseType)
structure MyQualifiedIncludeOccurences =  Occurences(MyQualifiedIncludeDictSet)

structure MyQualifiedOccurences =  QualifiedOccurences (
   struct
      structure Include =  MyQualifiedIncludeOccurences;
      structure Qualifier =  MyQLOccurences;
      structure QualifiedBaseType =  MyQualifiedBaseType;
   end );
