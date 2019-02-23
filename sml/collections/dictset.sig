use "general/eqs.sig";

signature DictSet =
   sig
      structure Eqs: Eqs

      structure Dicts:
         sig
            type 'a dict
            val empty:            'a dict
            val map:              ('a -> 'b) -> 'a dict -> 'b dict
            val deref:            Eqs.T * 'a dict -> 'a Option.option
            val set:              Eqs.T * 'a * 'a dict -> 'a dict
            val all:              ('a -> bool) -> 'a dict -> bool
            val zip:              ('a dict) * ('b dict) -> ('a * 'b) dict
            val adjoin:           'a dict * 'a dict -> 'a dict
         end

      structure Sets:
         sig
            type T
            val empty:            T
            val getItem:          T -> (Eqs.T * T) Option.option
            val map:              (Eqs.T -> Eqs.T) -> T -> T
            val singleton:        Eqs.T -> T
            val is_empty:         T -> bool
            val adjunct:          Eqs.T * T -> T
            val drop:             Eqs.T * T -> T
            val drop_if_exists:   Eqs.T * T -> T Option.option
            val insert:           Eqs.T * T -> T
            val sum:              T * T -> T
            val union:            T * T -> T
            val cut:              T * T -> T
            val intersect:        T * T -> T
            val subseteq:         T * T -> bool
            val eq:               T * T -> bool
      
            val find:             (Eqs.T -> bool) -> T -> Eqs.T Option.option
      
            val ofind:            (Eqs.T -> 'b Option.option) -> T -> 'b Option.option
      
            val fe:               Eqs.T -> T
            val fop:              (Eqs.T -> T) -> T -> T
            val is_in:            Eqs.T * T -> bool
            val transition:       (Eqs.T * 'b -> 'b Option.option) -> T -> 'b -> 'b
         end

      val keys:             'a Dicts.dict -> Sets.T
   end;
