use "collections/naming_pointered_type_generating.sig";
use "collections/occurences.sig";
use "collections/onpt.sig";

functor ONPT(X:
   sig
      structure NamingPointeredTypeGenerating: NamingPointeredTypeGenerating
      structure Occurences: Occurences
      sharing NamingPointeredTypeGenerating.PointeredTypeExtended.BaseType = Occurences.DictSet.Eqs
   end ): ONPT =
   struct
      structure NamingPointeredTypeGenerating =  X.NamingPointeredTypeGenerating
      structure Occurences =  X.Occurences

      fun add occ npt
         =  Occurences.DictSet.Sets.transition
               (  fn (x, c) => Option.SOME(NamingPointeredTypeGenerating.add x c))
               (Occurences.get_multiple_occurences occ)
               npt
   end;
