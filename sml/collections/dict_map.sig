use "collections/dictset.sig";
use "general/type_map.sig";

signature DictMap =
   sig
      include TypeMap

      structure DictSet: DictSet
      sharing DictSet.Eqs = Start

   end;
