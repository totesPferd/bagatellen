use "collections/dictset.sig";
use "general/type.sig";
use "general/type_map.sig";

signature DictMap =
   sig
      include TypeMap

      structure DictSet: DictSet
      sharing DictSet.Eqs = Start

      val get_map: End.T DictSet.Dicts.dict -> Map.T

   end;
