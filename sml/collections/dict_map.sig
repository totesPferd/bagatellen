use "collections/dictset.sig";
use "general/map.sig";

signature DictMap =
   sig
      include Map
      structure DictSet: DictSet
      sharing Start =  DictSet.Eqs
   end;
