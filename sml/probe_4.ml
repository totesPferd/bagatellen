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

(*
structure MyDblLiteralsPointeredMap: PointeredDoubleMap =  PointeredDoubleMap (
   struct
      structure FstMap =  MyQLLiteralsPointeredSingleton.PointeredMap;
      structure SndMap =  MyPELLiteralsPointeredSingleton.PointeredMap;
      structure Pair =  MyDblLiteralsMapPair;
      structure PointerType =  MyDblLiteralsPointeredType.PointerType;
   end );

structure MyDblLiteralsPointeredSingleton: PointeredDoubleSingleton =  PointeredDoubleSingleton (
   struct
      structure PointeredType =  MyDblLiteralsPointeredType;
      structure PointeredMap =  MyDblLiteralsPointeredMap;
      structure PointerType =  MyDblLiteralsPointeredType.PointerType;
      structure FstSingleton =  MyQLLiteralsPointeredSingleton;
      structure SndSingleton =  MyPELLiteralsPointeredSingleton;
   end );
*)
