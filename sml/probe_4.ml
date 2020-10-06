use "probe_3.ml";

structure MyDblLiteralsStructure: DoubleStructure =  
   struct
      structure FstStruct =  MyQLLiteralsConstruction.Variables.Base.Single;
      structure SndStruct =  MyPELLiteralsConstruction.Variables.Base.Single;
   end;

structure MyDblLiteralsMapPair: PairType =  PairType (
   struct
      structure FstType =  MyQLLiteralsMap.Map;
      structure SndType =  MyPELLiteralsMap.Map;
   end );

structure MyDblLiteralsMap: DoubleMap =  DoubleMap (
   struct
      structure FstMap =  MyQLLiteralsMap;
      structure SndMap =  MyPELLiteralsMap;
      structure Pair =  MyDblLiteralsMapPair;
   end );

structure MyDblLiteralsTypeSum: SumType =  SumType (
   struct
      structure FstType =  MyQLLiteralsConstruction.Variables.Base.Single;
      structure SndType =  MyPELLiteralsConstruction.Variables.Base.Single;
   end );

structure MyDblLiteralsContainerTypePair: PairType =  PairType (
   struct
      structure FstType =  MyQLLiteralsPointeredTypeGenerating.PointeredTypeExtended.ContainerType;
      structure SndType =  MyPELLiteralsPointeredTypeGenerating.PointeredTypeExtended.ContainerType;
   end );

structure MyDblLiteralsPointerTypeSum: SumType =  SumType (
   struct
      structure FstType =  MyQLLiteralsPointeredTypeGenerating.PointeredTypeExtended.PointerType;
      structure SndType =  MyPELLiteralsPointeredTypeGenerating.PointeredTypeExtended.PointerType;
   end );

structure MyDblLiteralsPointeredType: DoublePointeredType =  DoublePointeredType (
   struct
      structure FstType =  MyQLLiteralsPointeredTypeGenerating.PointeredTypeExtended;
      structure SndType =  MyPELLiteralsPointeredTypeGenerating.PointeredTypeExtended;
      structure BaseStructure =  MyDblLiteralsStructure;
      structure BaseType =  MyDblLiteralsTypeSum;
      structure ContainerType =  MyDblLiteralsContainerTypePair;
      structure BaseStructureMap =  MyDblLiteralsMap;
      structure PointerType =  MyDblLiteralsPointerTypeSum;
   end );

structure MyDblLiteralsPointeredTypeExtended: DoublePointeredTypeExtended =  DoublePointeredTypeExtended (
   struct
      structure FstType =  MyQLLiteralsPointeredTypeGenerating.PointeredTypeExtended;
      structure SndType =  MyPELLiteralsPointeredTypeGenerating.PointeredTypeExtended;
      structure FstMap =  MyQLLiteralsMap;
      structure SndMap =  MyPELLiteralsMap;
      structure BaseStructure =  MyDblLiteralsStructure;
      structure BaseStructureMap =  MyDblLiteralsMap;
      structure BaseType =  MyDblLiteralsTypeSum;
      structure ContainerType =  MyDblLiteralsContainerTypePair;
      structure PointerType =  MyDblLiteralsPointerTypeSum;
      structure DoublePointeredType =  MyDblLiteralsPointeredType;
   end );

structure MyDblVariablesBinaryRelationPair: PairType =  PairType (
   struct
      structure FstType =  MyQLVariablesBinaryRelation.Relation;
      structure SndType =  MyPELVariablesBinaryRelation.Relation;
   end );

structure MyDblVariablesBinaryRelation: DoubleBinaryRelation =  DoubleBinaryRelation (
   struct
      structure FstRelation =  MyQLVariablesBinaryRelation;
      structure SndRelation =  MyPELVariablesBinaryRelation;
      structure Pair =  MyDblVariablesBinaryRelationPair;
   end );

structure MyDblVariablesMapPair: PairType =  PairType (
   struct
      structure FstType =  MyQLVariablesMap.Map;
      structure SndType =  MyPELVariablesMap.Map;
   end );

structure MyDblVariablesMap: DoubleMap =  DoubleMap (
   struct
      structure FstMap =  MyQLVariablesMap;
      structure SndMap =  MyPELVariablesMap;
      structure Pair =  MyDblVariablesMapPair;
   end );

structure MyDblVariablesBaseSum: SumType =  SumType (
   struct
      structure FstType =  MyQLLiteralsConstruction.Variables.Base.Single;
      structure SndType =  MyPELLiteralsConstruction.Variables.Base.Single;
   end );

structure MyDblVariablesSum: SumType =  SumType (
   struct
      structure FstType =  MyQLLiteralsConstruction.Variables;
      structure SndType =  MyPELLiteralsConstruction.Variables;
   end );

structure MyDblVariableStructure: DoubleVariableStructure =  DoubleVariableStructure (
   struct
      structure Fst =  MyQLVariablesStructure;
      structure Snd =  MyPELVariablesStructure;
      structure Map =  MyDblVariablesMap;
      structure BinaryRelation =  MyDblVariablesBinaryRelation;
      structure BaseType =  MyDblVariablesBaseSum;
      structure VarType =  MyDblVariablesSum;
   end );

structure MyDblLiteralsMapPair: PairType =  PairType (
   struct
      structure FstType =  MyQLLiteralsPointeredSingleton.PointeredMap.Map;
      structure SndType =  MyPELLiteralsPointeredSingleton.PointeredMap.Map;
   end );

structure MyDblLiteralsPointeredMap: PointeredDoubleMap =  PointeredDoubleMap (
   struct
      structure FstPointeredMap =  MyQLLiteralsPointeredSingleton.PointeredMap;
      structure SndPointeredMap =  MyPELLiteralsPointeredSingleton.PointeredMap;
      structure Pair =  MyDblLiteralsMapPair;
      structure PointerType =  MyDblLiteralsPointerTypeSum;
   end );

structure MyDblLiteralsPointeredSingleton: PointeredDoubleSingleton =  PointeredDoubleSingleton (
   struct
      structure PointeredType =  MyDblLiteralsPointeredType;
      structure PointeredMap =  MyDblLiteralsPointeredMap;
      structure PointerType =  MyDblLiteralsPointerTypeSum;
      structure FstSingleton =  MyQLLiteralsPointeredSingleton;
      structure SndSingleton =  MyPELLiteralsPointeredSingleton;
   end );

structure MyDblLiteralsPointeredComposeResultMapPair: PairType =  PairType (
   struct
      structure FstType =  MyQLLiteralsComposeMap.Result.Map;
      structure SndType =  MyPELLiteralsComposeMap.Result.Map;
   end );

structure MyDblLiteralsPointeredComposeResult: PointeredDoubleMap =  PointeredDoubleMap (
   struct
      structure FstPointeredMap =  MyQLLiteralsComposeMap.Result;
      structure SndPointeredMap =  MyPELLiteralsComposeMap.Result;
      structure Pair =  MyDblLiteralsPointeredComposeResultMapPair;
      structure PointerType =  MyDblLiteralsPointerTypeSum;
   end );

structure MyDblLiteralsPointeredComposeMap: PointeredComposeMap =  PointeredDoubleComposeMap (
   struct
      structure FstCM =  MyQLLiteralsComposeMap;
      structure SndCM =  MyPELLiteralsComposeMap;
      structure ADM =  MyDblLiteralsMap;
      structure BDM =  MyDblLiteralsPointeredSingleton.PointeredMap;
      structure Result =  MyDblLiteralsPointeredComposeResult;
      structure Start =  MyDblLiteralsMap.DoubleStart;
      structure Middle =  MyDblLiteralsMap.DoubleEnd;
      structure End =  MyDblLiteralsPointeredSingleton.PointeredMap.DoubleEnd;
      structure PointerType =  MyDblLiteralsPointerTypeSum;
   end );

structure MyDbLiteralsPointeredGenerationPointeredMapPair: PairType =  PairType (
   struct
      structure FstType =  MyQLLiteralsPointeredGeneration.PointeredMap.Map;
      structure SndType =  MyPELLiteralsPointeredGeneration.PointeredMap.Map;
   end );

structure MyDblLiteralsPointeredGenerationPointeredMap: PointeredDoubleMap =  PointeredDoubleMap (
   struct
      structure FstPointeredMap =  MyQLLiteralsPointeredGeneration.PointeredMap;
      structure SndPointeredMap =  MyPELLiteralsPointeredGeneration.PointeredMap;
      structure Pair =  MyDbLiteralsPointeredGenerationPointeredMapPair;
      structure PointerType =  MyDblLiteralsPointerTypeSum;
   end );

structure MyDblLiteralsPointeredGeneration: PointeredGeneration =  PointeredDoubleGeneration (
   struct
      structure PointeredMap =  MyDblLiteralsPointeredGenerationPointeredMap;
      structure Start =  MyDblLiteralsPointeredType;
      structure End =  MyDblLiteralsPointeredType;
      structure PointerType =  MyDblLiteralsPointerTypeSum;
      structure FstPointeredGeneration =  MyQLLiteralsPointeredGeneration;
      structure SndPointeredGeneration =  MyPELLiteralsPointeredGeneration;
   end );

structure MyDblLiteralsPointeredFunctor: PointeredFunctor =  PointeredFunctor (
   struct
      structure Start =  MyDblLiteralsPointeredType;
      structure End =  MyDblLiteralsPointeredType;
      structure Map =  MyDblLiteralsMap;
      structure ComposeMap =  MyDblLiteralsPointeredComposeMap;
      structure Generation =  MyDblLiteralsPointeredGeneration;
      structure Singleton =  MyDblLiteralsPointeredSingleton;
      structure PointerType =  MyDblLiteralsPointerTypeSum;
   end );

structure MyDblLiteralsAllZipRelationPair: PairType =  PairType (
   struct
      structure FstType =  MyQLLiteralsPointeredTypeGenerating.AllZip.BinaryRelation.Relation;
      structure SndType =  MyPELLiteralsPointeredTypeGenerating.AllZip.BinaryRelation.Relation;
   end );

structure MyDblLiteralsAllZip =  DoubleAllZip (
   struct
      structure Fst =  MyQLLiteralsPointeredTypeGenerating.AllZip;
      structure Snd =  MyPELLiteralsPointeredTypeGenerating.AllZip;
      structure RelationPair =  MyDblLiteralsAllZipRelationPair;
      structure DoublePointeredType =  MyDblLiteralsPointeredType;
   end );
