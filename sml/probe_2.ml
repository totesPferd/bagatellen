use "probe_1.ml";

structure MyConstructors =  QLConstructors(
   struct
      structure M =  Modules
      structure Q =  Qualifier
   end );

structure MyLiteralsConstruction =  LiteralsConstruction(
   struct
      structure C =  MyConstructors
      structure PCT =  UnitPolymorphicContainerType
      structure PV =  PolymorphicVariables
   end );

structure MyLiteralsBinaryRelation: BaseBinaryRelation =
   struct
      structure Domain =  MyLiteralsConstruction.Variables.Base.Single
      structure Relation =
         struct
            type T =  Domain.T * Domain.T -> bool
         end
      fun apply f (x, y) = f (x, y)
      fun get_binary_relation f =  f
   end;

structure MyLiteralsMap: BaseMap =
   struct
      structure Start =  MyLiteralsConstruction.Variables.Base.Single
      structure End =  MyLiteralsConstruction.Variables.Base.Single
      structure Map =
         struct
            type T =  Start.T -> End.T
         end

      fun apply f x =  f x
      fun get_map f =  f
   end;

structure MyLiteralsPointeredTypeGenerating =  UnitPointeredTypeGenerating(
   struct
      structure BaseType =  MyLiteralsConstruction.Variables.Base.Single
      structure BaseStructureMap =  MyLiteralsMap
      structure BinaryRelation =  MyLiteralsBinaryRelation
      structure PolymorphicContainerType =  UnitPolymorphicContainerType
   end );

structure MyVariablesDictSet =  DictSet(MyLiteralsConstruction.Variables)
structure MyOccurences =  Occurences(MyVariablesDictSet)

structure MyDictMap =  DictMap(
   struct
      structure DS =  MyVariablesDictSet
      structure End =  MyLiteralsConstruction.Variables
   end );

structure MyVariablesBinaryRelation: BaseBinaryRelation =
   struct
      structure Domain =  MyLiteralsConstruction.Variables
      structure Relation =
         struct
            type T =  Domain.T * Domain.T -> bool
         end
      fun apply f (x, y) = f (x, y)
      fun get_binary_relation f =  f
   end;

structure MyVariablesMap: BaseMap =
   struct
      structure Start =  MyLiteralsConstruction.Variables
      structure End =  MyLiteralsConstruction.Variables
      structure Map =
         struct
            type T =  Start.T -> End.T
         end

      fun apply f x =  f x
      fun get_map f =  f
   end;

structure MyVariablesStructure =  VariableAsStructure(
   struct
      structure Variables =  MyLiteralsConstruction.Variables
      structure BinaryRelation =  MyVariablesBinaryRelation
      structure Map =  MyVariablesMap
   end );

structure MyVariablesPointeredTypeGenerating =  UnitPointeredTypeGenerating(
   struct
      structure BaseType =  MyLiteralsConstruction.Variables
      structure BaseStructureMap =  MyVariablesMap
      structure BinaryRelation =  MyVariablesBinaryRelation
      structure PolymorphicContainerType =  UnitPolymorphicContainerType
   end );

structure MyLiteralsPointeredGeneration =  UnitUnitPointeredGeneration(
   struct
      structure From =  MyLiteralsPointeredTypeGenerating
      structure To =  MyLiteralsPointeredTypeGenerating
   end );

structure MyLiteralsPointeredMap: PointeredBaseMap =
   struct
      structure PointerType =  MyLiteralsPointeredTypeGenerating.PointeredTypeExtended.PointerType
      structure Start =  MyLiteralsPointeredTypeGenerating.PointeredTypeExtended.BaseType
      structure End =  MyLiteralsPointeredTypeGenerating.PointeredTypeExtended.ContainerType
      structure Map =
         struct
            type T =  PointerType.T * Start.T -> End.T
         end

      fun apply f (p, x) =  f (p, x)
      fun get_map f =  f

   end;

structure MyLiteralsPointeredSingleton =  PointeredBaseSingleton(
   struct
      structure PointeredType =  MyLiteralsPointeredTypeGenerating.PointeredTypeExtended
      val singleton =  MyLiteralsPointeredTypeGenerating.singleton
   end );

structure MyLiteralsComposeMap =  PointeredBaseComposeMap(
   struct
      structure A =  MyLiteralsMap
      structure B =  MyLiteralsPointeredSingleton.PointeredMap
      structure Result =  MyLiteralsPointeredGeneration.PointeredMap
      structure PointerType =  MyLiteralsPointeredTypeGenerating.PointeredTypeExtended.PointerType
   end );

structure MyLiteralsPointeredFunctor =  PointeredFunctor(
   struct
      structure Start =  MyLiteralsPointeredTypeGenerating.PointeredTypeExtended
      structure End =  MyLiteralsPointeredTypeGenerating.PointeredTypeExtended
      structure Map =  MyLiteralsMap
      structure ComposeMap =  MyLiteralsComposeMap
      structure Generation =  MyLiteralsPointeredGeneration
      structure PointerType =  MyLiteralsPointeredTypeGenerating.PointeredTypeExtended.PointerType
      structure Singleton =  MyLiteralsPointeredSingleton
   end );

structure MyLiterals =  Literals(
   struct
      structure BaseMap =  MyLiteralsMap
      structure VarMap =  MyVariablesMap
      structure VariableStructure =  MyVariablesStructure
      structure Occ =  MyOccurences
      structure LiteralsConstruction =  MyLiteralsConstruction
      structure PointeredTypeGenerating =  MyLiteralsPointeredTypeGenerating
      structure PointeredFunctor =  MyLiteralsPointeredFunctor
      structure AllZip =  MyLiteralsPointeredTypeGenerating.AllZip
   end );

structure MyVariablesPointeredGeneration =  UnitUnitPointeredGeneration(
   struct
      structure From =  MyVariablesPointeredTypeGenerating
      structure To =  MyVariablesPointeredTypeGenerating
   end );

structure MyVariablesPointeredMap: PointeredBaseMap =
   struct
      structure PointerType =  MyVariablesPointeredTypeGenerating.PointeredTypeExtended.PointerType
      structure Start =  MyVariablesPointeredTypeGenerating.PointeredTypeExtended.BaseType
      structure End =  MyVariablesPointeredTypeGenerating.PointeredTypeExtended.ContainerType
      structure Map =
         struct
            type T =  PointerType.T * Start.T -> End.T
         end

      fun apply f (p, x) =  f (p, x)
      fun get_map f =  f

   end;

structure MyVariablesPointeredSingleton =  PointeredBaseSingleton(
   struct
      structure PointeredType =  MyVariablesPointeredTypeGenerating.PointeredTypeExtended
      val singleton =  MyVariablesPointeredTypeGenerating.singleton
   end );

structure MyVariablesComposeMap =  PointeredBaseComposeMap(
   struct
      structure A =  MyVariablesMap
      structure B =  MyVariablesPointeredSingleton.PointeredMap
      structure Result =  MyVariablesPointeredGeneration.PointeredMap
      structure PointerType =  MyVariablesPointeredTypeGenerating.PointeredTypeExtended.PointerType
   end );

structure MyVariablesPointeredFunctor =  PointeredFunctor(
   struct
      structure Start =  MyVariablesPointeredTypeGenerating.PointeredTypeExtended
      structure End =  MyVariablesPointeredTypeGenerating.PointeredTypeExtended
      structure Map =  MyVariablesMap
      structure ComposeMap =  MyVariablesComposeMap
      structure Generation =  MyVariablesPointeredGeneration
      structure PointerType =  MyVariablesPointeredTypeGenerating.PointeredTypeExtended.PointerType
      structure Singleton =  MyVariablesPointeredSingleton
   end );

structure MyVariableContexts =  VariableContexts(
   struct
      structure AZ =  MyVariablesPointeredTypeGenerating.AllZip
      structure PF =  MyVariablesPointeredFunctor
      structure PT =  MyVariablesPointeredTypeGenerating.PointeredTypeExtended
      structure DM =  MyDictMap
      structure DS =  MyDictMap.DictSet
      structure VM =  MyVariablesMap
      structure VarStruct =  MyVariablesStructure
   end );

structure MyContecteds =  Contecteds(
   struct
      structure Lit =  MyLiterals
      structure VarCtxt =  MyVariableContexts
   end );

structure MyProof =  Proof(
   struct
      structure Contecteds =  MyContecteds
      structure PointeredBaseMap =  MyLiteralsPointeredMap
      structure PointerType =  PointeredBaseMap.PointerType
      structure PointeredGeneration =  MyLiteralsPointeredGeneration
      structure PointeredSingleton =  MyLiteralsPointeredSingleton
   end );
