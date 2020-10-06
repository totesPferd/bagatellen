use "probe_4.ml";

structure MyQualifiedLiteralsConstruction =  QualifiedLiteralsConstruction (
   struct
      structure C =  PELConstructors;
      structure Q =  MyQLLiterals;
      structure PCT =  NamingPolymorphicContainerType;
      structure PV =  PolymorphicVariables;
   end );
