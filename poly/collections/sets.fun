use "collections/dictset.fun";
use "collections/eqs.sig";
use "collections/sets.sig";

functor Sets(E: Eqs) :> Sets =
   struct
      structure DictSet = DictSet(E)
      structure Eqs = DictSet.Eqs

      type T =  DictSet.set

      val empty =         DictSet.empty_s
      val map =           DictSet.map_s
      val singleton =     DictSet.singleton
      val drop =          DictSet.drop_s
      val insert =        DictSet.insert_s
      val cut =           DictSet.cut
      val union =         DictSet.union

      val is_member =     DictSet.is_member_s
      val subseteq  =     DictSet.subseteq_s

   end;
