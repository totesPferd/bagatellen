use "general/transition_type_by_list.fun";
use "general/dict_set_simple/set_impl.sig";
use "general/eq_type.sig";

functor DictSetSimpleSet(E: EqType): DictSetSimpleSetImpl =
   struct
      type base_t =  E.T
      type T =  base_t list
      val empty =  nil
      val getItem =  List.getItem
      fun map f (s: T) =  List.map f s
      fun singleton x =  [ x ]
      fun is_in(x, s) =  List.exists (fn (y) => E.eq(x, y)) s
      val is_empty =  List.null
      fun adjunct(x, s) =  x :: s
      fun drop(x, s) =  List.filter (fn (y) => not(E.eq(x, y))) s
      fun drop_if_exists(x, s)
        = if is_in(x, s)
          then
             Option.SOME (drop(x, s))
          else
             Option.NONE
      fun insert(x, s)
        = if is_in(x, s)
          then
             s
          else
             x :: s
      fun sum (l_1, l_2) =  l_1 @ l_2
      fun union(nil, t) =  t
      | union(x :: s, t) =  insert (x, union(s, t))
      fun cut(s, nil) =  s
        | cut(s, y :: t) =  cut(drop(y, s), t)
      fun intersect(nil, l_2) =  nil
        | intersect((x :: l_1), l_2)
        = let
             val tail =  intersect(l_1, l_2)
          in
             if is_in(x, l_2)
             then
                x :: tail
             else
                tail
          end
      fun subseteq(s, t) =  List.all (fn (x) => is_in(x, t)) s

      fun find P s =  List.find P s

      fun ofind f nil =  Option.NONE
        | ofind f (hd :: tl)
        = case(f hd) of
             Option.NONE => ofind f tl
          |  Option.SOME y =>  Option.SOME y

      fun fe b =  [ b ]
      structure Acc =  TransitionTypeByList(
         struct
            type base_t =  base_t
         end )
      fun transition phi s b =  Acc.transition phi s b
      fun fop phi s
        = transition (
             fn (x, b) => union (phi x, b()) )
          s
          nil
      fun next nil =  Option.NONE
        | next (hd::tl) =  Option.SOME (hd, tl)
   end
