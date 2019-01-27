use "collections/type.sig";

signature Eqs =
   sig
      structure Type: Type
      val eq: Type.T * Type.T -> bool
   end;
