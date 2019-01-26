signature Constructors =
   sig
      eqtype Constructor

      val eq: Constructor * Constructor -> bool
   end;
