use "collections/naming_pointered_type_extension.sig";
use "collections/occurences.sig";

signature ONPT =
   sig
      structure NamingPointeredTypeExtension: NamingPointeredTypeExtension
      structure Occurences: Occurences
      sharing NamingPointeredTypeExtension.PointeredType2.BaseType = Occurences.DictSet.Eqs

      val add: Occurences.occurences -> NamingPointeredTypeExtension.PointeredType2.ContainerType.T -> NamingPointeredTypeExtension.PointeredType2.ContainerType.T

   end;
