use "collections/option.ml";

signature VariableType =
   sig
      type 'a Variable

      val new:         unit -> 'a Variable ref
      val copy:        'a Variable ref -> 'a Variable ref

      val get_val:     'a Variable ref -> 'a option
      val is_settable: 'a Variable ref -> bool
      val set_val:     'a -> 'a Variable ref -> bool
   end;
