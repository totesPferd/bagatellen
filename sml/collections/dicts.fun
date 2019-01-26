use "collections/dictset.fun";
use "collections/dicts.sig";
use "collections/eqs.sig";
use "collections/sets.fun";

functor Dicts(E: Eqs): Dicts =
   struct
      structure DictSet = DictSet(E)
      structure Eqs     = DictSet.Eqs
      structure Sets    = Sets(E)

      type 'a T =  'a DictSet.dict

      val empty =         DictSet.empty_d
      val map =           DictSet.map_d
      val set =           DictSet.set_d
      val deref =         DictSet.deref

      val keys =           DictSet.keys
   end;
