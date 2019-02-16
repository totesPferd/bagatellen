use "collections/naming_pointered_type.sig";
use "collections/occurences.sig";
use "collections/onpt.sig";

functor ONPT(X:
   sig
      structure NamingPointeredType: NamingPointeredType
      structure Occurences: Occurences
      sharing NamingPointeredType.PointeredType.BaseType = Occurences.DictSet.Eqs
   end ) (*: ONPT*) =
   struct
      structure NamingPointeredType =  X.NamingPointeredType
      structure Occurences =  X.Occurences

      fun add occ npt
         =  Occurences.DictSet.Sets.transition
               (  fn (x, c) => Option.SOME(NamingPointeredType.add x c))
               (Occurences.get_multiple_occurences occ)
               npt
   end;
