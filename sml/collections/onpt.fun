use "collections/naming_pointered_type_extension.sig";
use "collections/occurences.sig";
use "collections/onpt.sig";

functor ONPT(X:
   sig
      structure NamingPointeredTypeExtension: NamingPointeredTypeExtension
      structure Occurences: Occurences
      sharing NamingPointeredTypeExtension.PointeredType.BaseType = Occurences.DictSet.Eqs
   end ) (*: ONPT*) =
   struct
      structure NamingPointeredTypeExtension =  X.NamingPointeredTypeExtension
      structure Occurences =  X.Occurences

      fun add occ npt
         =  Occurences.DictSet.Sets.transition
               (  fn (x, c) => Option.SOME(NamingPointeredTypeExtension.add x c))
               (Occurences.get_multiple_occurences occ)
               npt
   end;
