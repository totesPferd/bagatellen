use "collections/eqs.sig";
use "collections/sets.sig";

signature Dicts =
   sig
      structure Eqs: Eqs
      structure Sets: Sets
      sharing Sets.Eqs = Eqs

      type 'b T

      val empty: 'b T;
      val set:   Eqs.T * 'b * 'b T -> 'b T
      val deref: Eqs.T * 'b T -> 'b Option.option
      val all:   ('b -> bool) -> 'b T -> bool
      val zip:   ('a T) * ('b T) -> ('a * 'b) T

      val map:   ('a -> 'b) -> 'a T -> 'b T

      val keys:  'b T -> Sets.T

   end
