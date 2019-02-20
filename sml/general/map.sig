use "general/type.sig";

signature Map =
   sig
      structure Start: Type
      structure End: Type

      type T

      val apply: T -> Start.T -> End.T

   end;
