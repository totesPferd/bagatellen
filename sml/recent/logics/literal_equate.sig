use "general/eq_type.sig";

signature LiteralEquate =
   sig
      include EqType
      val equate: T * T -> bool
   end
