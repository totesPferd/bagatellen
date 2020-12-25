use "logics/literal_equate.sig";
use "logics/multi_literal.sig";

signature Literal =
   sig
      structure Single: LiteralEquate
      structure Multi: MultiLiteral
   end
