signature Variables =
   sig
      type Variable
      val veq:   Variable * Variable -> bool
      val vcopy: Variable -> Variable
   end;
