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

structure MyPELVariablesPointeredTypeGenerating =  NamingPointeredTypeGenerating(
   struct
      structure BaseType =  MyPELLiteralsConstruction.Variables
      structure BaseStructureMap =  MyPELVariablesMap
      structure BinaryRelation =  MyPELVariablesBinaryRelation
      structure PolymorphicContainerType =  NamingPolymorphicContainerType
   end );

structure MyPELLiteralsPointeredGeneration =  NamingNamingPointeredGeneration(
   struct
      structure From =  MyPELLiteralsPointeredTypeGenerating
      structure To =  MyPELLiteralsPointeredTypeGenerating
   end );

structure MyPELLiteralsPointeredMap: PointeredBaseMap =
   struct
      structure PointerType =  MyPELLiteralsPointeredTypeGenerating.PointeredTypeExtended.PointerType
      structure Start =  MyPELLiteralsPointeredTypeGenerating.PointeredTypeExtended.BaseType
      structure End =  MyPELLiteralsPointeredTypeGenerating.PointeredTypeExtended.ContainerType
      structure Map =
         struct
            type T =  PointerType.T * Start.T -> End.T
         end

      fun apply f (p, x) =  f (p, x)
      fun get_map f =  f

   end;

structure MyPELLiteralsPointeredSingleton =  PointeredBaseSingleton(
   struct
      structure PointeredType =  MyPELLiteralsPointeredTypeGenerating.PointeredTypeExtended
      val singleton =  MyPELLiteralsPointeredTypeGenerating.singleton
   end );

structure MyPELLiteralsComposeMap =  PointeredBaseComposeMap(
   struct
      structure A =  MyPELLiteralsMap
      structure B =  MyPELLiteralsPointeredSingleton.PointeredMap
      structure Result =  MyPELLiteralsPointeredGeneration.PointeredMap
      structure PointerType =  MyPELLiteralsPointeredTypeGenerating.PointeredTypeExtended.PointerType
   end );

structure MyPELLiteralsPointeredFunctor =  PointeredFunctor(
   struct
      structure Start =  MyPELLiteralsPointeredTypeGenerating.PointeredTypeExtended
      structure End =  MyPELLiteralsPointeredTypeGenerating.PointeredTypeExtended
      structure Map =  MyPELLiteralsMap
      structure ComposeMap =  MyPELLiteralsComposeMap
      structure Generation =  MyPELLiteralsPointeredGeneration
      structure PointerType =  MyPELLiteralsPointeredTypeGenerating.PointeredTypeExtended.PointerType
      structure Singleton =  MyPELLiteralsPointeredSingleton
   end );

structure MyPELLiterals =  Literals(
   struct
      structure BaseMap =  MyPELLiteralsMap
      structure VarMap =  MyPELVariablesMap
      structure VariableStructure =  MyPELVariablesStructure
      structure Occ =  MyPELOccurences
      structure LiteralsConstruction =  MyPELLiteralsConstruction
      structure PointeredTypeGenerating =  MyPELLiteralsPointeredTypeGenerating
      structure PointeredFunctor =  MyPELLiteralsPointeredFunctor
      structure AllZip =  MyPELLiteralsPointeredTypeGenerating.AllZip
   end );

structure MyPELVariablesPointeredGeneration =  NamingNamingPointeredGeneration(
   struct
      structure From =  MyPELVariablesPointeredTypeGenerating
      structure To =  MyPELVariablesPointeredTypeGenerating
   end );

structure MyPELVariablesPointeredMap: PointeredBaseMap =
   struct
      structure PointerType =  MyPELVariablesPointeredTypeGenerating.PointeredTypeExtended.PointerType
      structure Start =  MyPELVariablesPointeredTypeGenerating.PointeredTypeExtended.BaseType
      structure End =  MyPELVariablesPointeredTypeGenerating.PointeredTypeExtended.ContainerType
      structure Map =
         struct
            type T =  PointerType.T * Start.T -> End.T
         end

      fun apply f (p, x) =  f (p, x)
      fun get_map f =  f

   end;

structure MyPELVariablesPointeredSingleton =  PointeredBaseSingleton(
   struct
      structure PointeredType =  MyPELVariablesPointeredTypeGenerating.PointeredTypeExtended
      val singleton =  MyPELVariablesPointeredTypeGenerating.singleton
   end );

structure MyPELVariablesComposeMap =  PointeredBaseComposeMap(
   struct
      structure A =  MyPELVariablesMap
      structure B =  MyPELVariablesPointeredSingleton.PointeredMap
      structure Result =  MyPELVariablesPointeredGeneration.PointeredMap
      structure PointerType =  MyPELVariablesPointeredTypeGenerating.PointeredTypeExtended.PointerType
   end );

structure MyPELVariablesPointeredFunctor =  PointeredFunctor(
   struct
      structure Start =  MyPELVariablesPointeredTypeGenerating.PointeredTypeExtended
      structure End =  MyPELVariablesPointeredTypeGenerating.PointeredTypeExtended
      structure Map =  MyPELVariablesMap
      structure ComposeMap =  MyPELVariablesComposeMap
      structure Generation =  MyPELVariablesPointeredGeneration
      structure PointerType =  MyPELVariablesPointeredTypeGenerating.PointeredTypeExtended.PointerType
      structure Singleton =  MyPELVariablesPointeredSingleton
   end );

structure MyPELVariableContexts =  VariableContexts(
   struct
      structure AZ =  MyPELVariablesPointeredTypeGenerating.AllZip
      structure PF =  MyPELVariablesPointeredFunctor
      structure PT =  MyPELVariablesPointeredTypeGenerating.PointeredTypeExtended
      structure DM =  MyPELDictMap
      structure DS =  MyPELDictMap.DictSet
      structure VM =  MyPELVariablesMap
      structure VarStruct =  MyPELVariablesStructure
   end );

structure MyPELContecteds =  Contecteds(
   struct
      structure Lit =  MyPELLiterals
      structure VarCtxt =  MyPELVariableContexts
   end );

structure MyPELProof =  Proof(
   struct
      structure Contecteds =  MyPELContecteds
      structure PointeredBaseMap =  MyPELLiteralsPointeredMap
      structure PointerType =  PointeredBaseMap.PointerType
      structure PointeredGeneration =  MyPELLiteralsPointeredGeneration
      structure PointeredSingleton =  MyPELLiteralsPointeredSingleton
   end );

