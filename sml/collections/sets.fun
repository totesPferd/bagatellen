use "collections/dictset.sig";
use "collections/sets.sig";

functor Sets(D: DictSet): Sets =
   struct
      structure Eqs = D.Eqs

      type T =  D.set

      val empty =           D.empty_s
      val getItem =         D.getItem_s
      val map =             D.map_s
      val singleton =       D.singleton
      val adjunct =         D.adjunct_s
      val drop =            D.drop_s
      val drop_if_exists =  D.drop_if_exists_s
      val insert =          D.insert_s
      val sum =             D.sum_s
      val cut =             D.cut
      val union =           D.union
      val intersect =       D.intersect

      val is_member =       D.is_member_s
      val is_empty =        D.is_empty_s
      val subseteq  =       D.subseteq_s
      val eq =              D.eq_s

      val find =            D.find_s

      val ofind =           D.ofind_s
      val transition =      D.transition_s

   end;
