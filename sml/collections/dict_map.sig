use "collections/dictset.sig";
use "general/base_map.sig";

signature DictMap =
   sig
      structure DictSet: DictSet
      structure Start: Type
      structure End: Type
      structure Map: Type
      sharing DictSet.Eqs = Start

      val apply: Map.T -> Start.T -> End.T

   end;
