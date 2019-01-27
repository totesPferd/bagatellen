use "collections/eqs.sig";

signature DictSet =
   sig
      structure Eqs: Eqs

      type 'a dict
      type set

      val empty_d:          'a dict
      val map_d:            ('a -> 'b) -> 'a dict -> 'b dict
      val keys:             'a dict -> set
      val deref:            Eqs.Type.T * 'a dict -> 'a Option.option
      val set_d:            Eqs.Type.T * 'a * 'a dict -> 'a dict

      val empty_s:          set
      val map_s:            (Eqs.Type.T -> Eqs.Type.T) -> set -> set
      val singleton:        Eqs.Type.T -> set
      val is_empty_s:       set -> bool
      val is_member_s:      Eqs.Type.T * set -> bool
      val drop_s:           Eqs.Type.T * set -> set
      val drop_if_exists_s: Eqs.Type.T * set -> set Option.option
      val insert_s:         Eqs.Type.T * set -> set
      val union:            set * set -> set
      val cut:              set * set -> set
      val subseteq_s:       set * set -> bool

      val pmap_s:           (Eqs.Type.T -> Eqs.Type.T Option.option) -> set -> set Option.option
   end;
