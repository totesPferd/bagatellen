use "general/eq_type.sig";
use "logics/variable.sig";

signature LiteralEquate =
   sig
      include EqType
      val equate: T * T -> bool

      structure Variable: Variable
   end
