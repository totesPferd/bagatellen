use "collections/type.sig";

signature Monoid =
   sig
      structure Base: Type
      val plus: Base.T * Base.T -> Base.T
      val zero: Base.T
   end;
