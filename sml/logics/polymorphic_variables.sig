signature PolymorphicVariables =
   sig
      eqtype 'a Variable

      val new:         unit -> 'a Variable
      val copy:        'a Variable -> 'a Variable
      val fcopy:       ('a -> 'b) -> 'a Variable -> 'b Variable

      val eq:          'a Variable * 'a Variable -> bool

      val get_val:     'a Variable -> 'a Option.option
      val is_settable: 'a Variable -> bool
      val set_val:     'a -> 'a Variable -> bool
   end;
