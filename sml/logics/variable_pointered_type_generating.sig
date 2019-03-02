use "collections/pointered_type_generating.sig";
use "logics/construction.sig";

signature VariablePointeredTypeGenerating =
   sig
      structure LiteralsConstruction: LiteralsConstruction
      structure PointeredTypeGenerating: PointeredTypeGenerating
      sharing LiteralsConstruction.PolymorphicContainerType = PointeredTypeGenerating.PolymorphicContainerType
      sharing LiteralsConstruction.Variables =  PointeredTypeGenerating.BaseType
   end;
