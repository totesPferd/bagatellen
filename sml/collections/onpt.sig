use "collections/naming_pointered_type_generating.sig";
use "collections/occurences.sig";

signature ONPT =
   sig
      structure NamingPointeredTypeGenerating: NamingPointeredTypeGenerating
      structure Occurences: Occurences
      sharing NamingPointeredTypeGenerating.PointeredTypeExtended.BaseType = Occurences.DictSet.Eqs

      val add: Occurences.occurences -> NamingPointeredTypeGenerating.PointeredTypeExtended.ContainerType.T -> NamingPointeredTypeGenerating.PointeredTypeExtended.ContainerType.T

   end;
