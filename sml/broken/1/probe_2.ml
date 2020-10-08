use "probe_1.ml";

structure MyQLConstructors =  QLConstructors(
   struct
      structure M =  Modules
      structure Q =  Qualifier
   end );

structure MyQLLiteralsConstruction =  LiteralsConstruction(
   struct
      structure C =  MyQLConstructors
      structure PCT =  UnitPolymorphicContainerType
      structure PV =  PolymorphicVariables
   end );

structure MyQLLiteralsBinaryRelation: BaseBinaryRelation =
   struct
      structure Domain =  MyQLLiteralsConstruction.Variables.Base.Single
      structure Relation =
         struct
            type T =  Domain.T * Domain.T -> bool
         end
      fun apply f (x, y) = f (x, y)
      fun get_binary_relation f =  f
   end;

structure MyQLLiteralsMap: BaseMap =
   struct
      structure Start =  MyQLLiteralsConstruction.Variables.Base.Single
      structure End =  MyQLLiteralsConstruction.Variables.Base.Single
      structure Map =
         struct
            type T =  Start.T -> End.T
         end

      fun apply f x =  f x
      fun get_map f =  f
   end;

structure MyQLLiteralsPointeredTypeGenerating =  UnitPointeredTypeGenerating(
   struct
      structure BaseType =  MyQLLiteralsConstruction.Variables.Base.Single
      structure BaseStructureMap =  MyQLLiteralsMap
      structure BinaryRelation =  MyQLLiteralsBinaryRelation
      structure PolymorphicContainerType =  UnitPolymorphicContainerType
   end );

structure MyQLVariablesDictSet =  DictSet(MyQLLiteralsConstruction.Variables)
structure MyQLOccurences =  Occurences(MyQLVariablesDictSet)

structure MyQLDictMap =  DictMap(
   struct
      structure DS =  MyQLVariablesDictSet
      structure End =  MyQLLiteralsConstruction.Variables
   end );

structure MyQLVariablesBinaryRelation: BaseBinaryRelation =
   struct
      structure Domain =  MyQLLiteralsConstruction.Variables
      structure Relation =
         struct
            type T =  Domain.T * Domain.T -> bool
         end
      fun apply f (x, y) = f (x, y)
      fun get_binary_relation f =  f
   end;

structure MyQLVariablesMap: BaseMap =
   struct
      structure Start =  MyQLLiteralsConstruction.Variables
      structure End =  MyQLLiteralsConstruction.Variables
      structure Map =
         struct
            type T =  Start.T -> End.T
         end

      fun apply f x =  f x
      fun get_map f =  f
   end;

structure MyQLVariablesStructure =  VariableAsStructure(
   struct
      structure Variables =  MyQLLiteralsConstruction.Variables
      structure BinaryRelation =  MyQLVariablesBinaryRelation
      structure Map =  MyQLVariablesMap
   end );

structure MyQLVariablesPointeredTypeGenerating =  UnitPointeredTypeGenerating(
   struct
      structure BaseType =  MyQLLiteralsConstruction.Variables
      structure BaseStructureMap =  MyQLVariablesMap
      structure BinaryRelation =  MyQLVariablesBinaryRelation
      structure PolymorphicContainerType =  UnitPolymorphicContainerType
   end );

structure MyQLLiteralsPointeredGeneration =  UnitUnitPointeredGeneration(
   struct
      structure From =  MyQLLiteralsPointeredTypeGenerating
      structure To =  MyQLLiteralsPointeredTypeGenerating
   end );

structure MyQLLiteralsPointeredMap: PointeredBaseMap =
   struct
      structure PointerType =  MyQLLiteralsPointeredTypeGenerating.PointeredTypeExtended.PointerType
      structure Start =  MyQLLiteralsPointeredTypeGenerating.PointeredTypeExtended.BaseType
      structure End =  MyQLLiteralsPointeredTypeGenerating.PointeredTypeExtended.ContainerType
      structure Map =
         struct
            type T =  PointerType.T * Start.T -> End.T
         end

      fun apply f (p, x) =  f (p, x)
      fun get_map f =  f

   end;

structure MyQLLiteralsPointeredSingleton =  PointeredBaseSingleton(
   struct
      structure PointeredType =  MyQLLiteralsPointeredTypeGenerating.PointeredTypeExtended
      val singleton =  MyQLLiteralsPointeredTypeGenerating.singleton
   end );

structure MyQLLiteralsComposeMap =  PointeredBaseComposeMap(
   struct
      structure A =  MyQLLiteralsMap
      structure B =  MyQLLiteralsPointeredSingleton.PointeredMap
      structure Result =  MyQLLiteralsPointeredGeneration.PointeredMap
      structure PointerType =  MyQLLiteralsPointeredTypeGenerating.PointeredTypeExtended.PointerType
   end );

structure MyQLLiteralsPointeredFunctor =  PointeredFunctor(
   struct
      structure Start =  MyQLLiteralsPointeredTypeGenerating.PointeredTypeExtended
      structure End =  MyQLLiteralsPointeredTypeGenerating.PointeredTypeExtended
      structure Map =  MyQLLiteralsMap
      structure ComposeMap =  MyQLLiteralsComposeMap
      structure Generation =  MyQLLiteralsPointeredGeneration
      structure PointerType =  MyQLLiteralsPointeredTypeGenerating.PointeredTypeExtended.PointerType
      structure Singleton =  MyQLLiteralsPointeredSingleton
   end );

structure MyQLLiterals =  Literals(
   struct
      structure BaseMap =  MyQLLiteralsMap
      structure VarMap =  MyQLVariablesMap
      structure VariableStructure =  MyQLVariablesStructure
      structure Occ =  MyQLOccurences
      structure LiteralsConstruction =  MyQLLiteralsConstruction
      structure PointeredTypeGenerating =  MyQLLiteralsPointeredTypeGenerating
      structure PointeredFunctor =  MyQLLiteralsPointeredFunctor
      structure AllZip =  MyQLLiteralsPointeredTypeGenerating.AllZip
   end );

structure MyQLVariablesPointeredGeneration =  UnitUnitPointeredGeneration(
   struct
      structure From =  MyQLVariablesPointeredTypeGenerating
      structure To =  MyQLVariablesPointeredTypeGenerating
   end );

structure MyQLVariablesPointeredMap: PointeredBaseMap =
   struct
      structure PointerType =  MyQLVariablesPointeredTypeGenerating.PointeredTypeExtended.PointerType
      structure Start =  MyQLVariablesPointeredTypeGenerating.PointeredTypeExtended.BaseType
      structure End =  MyQLVariablesPointeredTypeGenerating.PointeredTypeExtended.ContainerType
      structure Map =
         struct
            type T =  PointerType.T * Start.T -> End.T
         end

      fun apply f (p, x) =  f (p, x)
      fun get_map f =  f

   end;

structure MyQLVariablesPointeredSingleton =  PointeredBaseSingleton(
   struct
      structure PointeredType =  MyQLVariablesPointeredTypeGenerating.PointeredTypeExtended
      val singleton =  MyQLVariablesPointeredTypeGenerating.singleton
   end );

structure MyQLVariablesComposeMap =  PointeredBaseComposeMap(
   struct
      structure A =  MyQLVariablesMap
      structure B =  MyQLVariablesPointeredSingleton.PointeredMap
      structure Result =  MyQLVariablesPointeredGeneration.PointeredMap
      structure PointerType =  MyQLVariablesPointeredTypeGenerating.PointeredTypeExtended.PointerType
   end );

structure MyQLVariablesPointeredFunctor =  PointeredFunctor(
   struct
      structure Start =  MyQLVariablesPointeredTypeGenerating.PointeredTypeExtended
      structure End =  MyQLVariablesPointeredTypeGenerating.PointeredTypeExtended
      structure Map =  MyQLVariablesMap
      structure ComposeMap =  MyQLVariablesComposeMap
      structure Generation =  MyQLVariablesPointeredGeneration
      structure PointerType =  MyQLVariablesPointeredTypeGenerating.PointeredTypeExtended.PointerType
      structure Singleton =  MyQLVariablesPointeredSingleton
   end );

structure MyQLVariableContexts =  VariableContexts(
   struct
      structure AZ =  MyQLVariablesPointeredTypeGenerating.AllZip
      structure PF =  MyQLVariablesPointeredFunctor
      structure PT =  MyQLVariablesPointeredTypeGenerating.PointeredTypeExtended
      structure DM =  MyQLDictMap
      structure DS =  MyQLDictMap.DictSet
      structure VM =  MyQLVariablesMap
      structure VarStruct =  MyQLVariablesStructure
   end );

structure MyQLContecteds =  Contecteds(
   struct
      structure Lit =  MyQLLiterals
      structure VarCtxt =  MyQLVariableContexts
   end );

structure MyQLProof =  Proof(
   struct
      structure Contecteds =  MyQLContecteds
      structure PointeredBaseMap =  MyQLLiteralsPointeredMap
      structure PointerType =  PointeredBaseMap.PointerType
      structure PointeredGeneration =  MyQLLiteralsPointeredGeneration
      structure PointeredSingleton =  MyQLLiteralsPointeredSingleton
   end );
