use "collections/eqs.sig";
use "collections/sets.sig";

signature Dicts =
   sig
      structure Eqs: Eqs
      structure Sets: Sets

      type 'b T

      val empty: 'b T;
      val set:   Eqs.T * 'b * 'b T -> 'b T
      val deref: Eqs.T * 'b T -> 'b Option.option

      val map:   ('a -> 'b) -> 'a T -> 'b T

      val keys:  'b T -> Sets.T

   end
