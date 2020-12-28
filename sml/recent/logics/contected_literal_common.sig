use "logics/contected_common.sig";

signature ContectedLiteralCommon =
   sig
      include ContectedCommon

      val equate: T * T -> bool
   end
