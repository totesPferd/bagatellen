use "logics/literal_equate.sig";

signature MultiLiteral =
   sig
      include LiteralEquate
      val empty: T
      val is_empty: T -> bool
   end
