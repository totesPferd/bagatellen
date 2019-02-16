use "collections/naming_pointered_type.sig";
use "collections/occurences.sig";

signature ONPT =
   sig
      structure NamingPointeredType: NamingPointeredType
      structure Occurences: Occurences
      sharing NamingPointeredType.PointeredType.BaseType = Occurences.DictSet.Eqs

      val add: Occurences.occurences -> NamingPointeredType.PointeredType.ContainerType.T -> NamingPointeredType.PointeredType.ContainerType.T

   end;
