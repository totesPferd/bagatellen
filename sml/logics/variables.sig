use "collections/type.sig";

signature Variables =
   sig
      structure Variable: Type
      structure Base: Type

      val new:         unit -> Variable.T
      val copy:        Variable.T -> Variable.T

      val eq:          Variable.T * Variable.T -> bool

      val get_val:     Variable.T -> Base.T Option.option
      val is_settable: Variable.T -> bool
      val set_val:     Base.T -> Variable.T -> bool
   end;
