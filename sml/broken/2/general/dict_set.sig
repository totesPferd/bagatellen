use "general/eq_type.sig";

signature DictSet =
   sig
      structure E: EqType

      structure Dicts:
         sig
            type 'a dict
            val empty:            'a dict
            val map:              ('a -> 'b) -> 'a dict -> 'b dict
            val deref:            E.T * 'a dict -> 'a Option.option
            val set:              E.T * 'a * 'a dict -> 'a dict
            val all:              ('a -> bool) -> 'a dict -> bool
            val zip:              ('a dict) * ('b dict) -> ('a * 'b) dict
            val adjoin:           'a dict * 'a dict -> 'a dict
            val singleton:        E.T * 'a -> 'a dict
         end

      structure Sets:
         sig
            type T
            val empty:            T
            val getItem:          T -> (E.T * T) Option.option
            val map:              (E.T -> E.T) -> T -> T
            val singleton:        E.T -> T
            val is_empty:         T -> bool
            val adjunct:          E.T * T -> T
            val drop:             E.T * T -> T
            val drop_if_exists:   E.T * T -> T Option.option
            val insert:           E.T * T -> T
            val sum:              T * T -> T
            val union:            T * T -> T
            val cut:              T * T -> T
            val intersect:        T * T -> T
            val subseteq:         T * T -> bool
            val eq:               T * T -> bool

            val find:             (E.T -> bool) -> T -> E.T Option.option

            val ofind:            (E.T -> 'b Option.option) -> T -> 'b Option.option

            val fe:               E.T -> T
            val fop:              (E.T -> T) -> T -> T
            val is_in:            E.T * T -> bool
            val transition:       (E.T * 'b -> 'b Option.option) -> T -> 'b -> 'b
         end

      val keys:             'a Dicts.dict -> Sets.T
   end;
