use "collections/eqs.sig";
use "collections/sets.sig";

signature Dicts =
   sig
      structure Eqs: Eqs

      type 'b T

      val empty: 'b T;
      val set:   Eqs.T * 'b * 'b T -> 'b T
      val deref: Eqs.T * 'b T -> 'b Option.option

      val map:   ('a -> 'b) -> 'a T -> 'b T

   end
