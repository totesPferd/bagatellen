use "collections/dictset.sig";
use "collections/dicts.sig";
use "collections/sets.fun";

functor Dicts(D: DictSet): Dicts =
   struct
      structure Eqs     = D.Eqs
      structure Sets    = Sets(D)

      type 'b T =        'b D.dict

      val empty =         D.empty_d
      val map =           D.map_d
      val set =           D.set_d
      val deref =         D.deref
      val all =           D.all_d

      val keys =          D.keys
   end;
