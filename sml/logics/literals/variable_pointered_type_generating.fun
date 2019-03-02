use "collections/pointered_type_generating.sig";
use "logics/construction.sig";
use "logics/variable_pointered_type_generating.sig";

functor VariablePointeredTypeGenerating(X:
   sig
      structure LC: LiteralsConstruction
      structure PTG: PointeredTypeGenerating
      sharing LC.PolymorphicContainerType = PTG.PolymorphicContainerType
      sharing LC.Variables =  PTG.PointeredTypeExtended.BaseType
   end ): VariablePointeredTypeGenerating =
   struct
      structure LiteralsConstruction =  X.LC
      structure PointeredTypeGenerating =  X.PTG
   end;
