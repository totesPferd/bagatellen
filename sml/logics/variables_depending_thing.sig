signature VariablesDependingThing =
   sig
      type L
      type V
      val veq: V * V -> bool
      val vcopy: V -> V 
      val pmap: (V -> V Option.option) -> L -> L Option.option
   end;
