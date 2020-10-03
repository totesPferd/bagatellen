use "probe_1.ml";

structure MyPELLiteralsConstruction =  LiteralsConstruction (
   struct
      structure C =  PELConstructors;
      structure PCT =  NamingPolymorphicContainerType;
      structure PV =  PolymorphicVariables;
   end );

structure MyPELLiteralsBinaryRelation: BaseBinaryRelation =
   struct
      structure Domain =  MyPELLiteralsConstruction.Variables.Base.Single
      structure Relation =
         struct
            type T =  Domain.T * Domain.T -> bool
         end
      fun apply f (x, y) = f (x, y)
      fun get_binary_relation f =  f
   end;

structure MyPELLiteralsMap: BaseMap =
   struct
      structure Start =  MyPELLiteralsConstruction.Variables.Base.Single
      structure End =  MyPELLiteralsConstruction.Variables.Base.Single
      structure Map =
         struct
            type T =  Start.T -> End.T
         end

      fun apply f x =  f x
      fun get_map f =  f
   end;

structure MyPELLiteralsPointeredTypeGenerating =  NamingPointeredTypeGenerating (
   struct
      structure BaseType =  MyPELLiteralsConstruction.Variables.Base.Single;
      structure BaseStructureMap =  MyPELLiteralsMap;
      structure BinaryRelation =  MyPELLiteralsBinaryRelation;
      structure PolymorphicContainerType =  NamingPolymorphicContainerType;
   end );

structure MyPELVariablesDictSet =  DictSet(MyPELLiteralsConstruction.Variables)
structure MyPELOccurences =  Occurences(MyPELVariablesDictSet)

structure MyPELDictMap =  DictMap(
   struct
      structure DS =  MyPELVariablesDictSet
      structure End =  MyPELLiteralsConstruction.Variables
   end );

structure MyPELVariablesBinaryRelation: BaseBinaryRelation =
   struct
      structure Domain =  MyPELLiteralsConstruction.Variables
      structure Relation =
         struct
            type T =  Domain.T * Domain.T -> bool
         end
      fun apply f (x, y) = f (x, y)
      fun get_binary_relation f =  f
   end;

structure MyPELVariablesMap: BaseMap =
   struct
      structure Start =  MyPELLiteralsConstruction.Variables
      structure End =  MyPELLiteralsConstruction.Variables
      structure Map =
         struct
            type T =  Start.T -> End.T
         end

      fun apply f x =  f x
      fun get_map f =  f
   end;

structure MyPELVariablesStructure =  VariableAsStructure(
   struct
      structure Variables =  MyPELLiteralsConstruction.Variables
      structure BinaryRelation =  MyPELVariablesBinaryRelation
      structure Map =  MyPELVariablesMap
   end );


