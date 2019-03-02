use "collections/naming_pointered_type_extension.sig";
use "collections/occurences.sig";

signature ONPT =
   sig
      structure NamingPointeredTypeExtension: NamingPointeredTypeExtension
      structure Occurences: Occurences
      sharing NamingPointeredTypeExtension.PointeredTypeExtended.BaseType = Occurences.DictSet.Eqs

      val add: Occurences.occurences -> NamingPointeredTypeExtension.PointeredTypeExtended.ContainerType.T -> NamingPointeredTypeExtension.PointeredTypeExtended.ContainerType.T

   end;
