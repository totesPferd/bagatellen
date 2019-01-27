use "collections/dictset.sig";
use "collections/eqs.sig";

functor DictSet(E: Eqs): DictSet =
   struct
      structure Eqs =  E

      type 'a dict =  { key: Eqs.T, value: 'a } list
      type set     =  Eqs.T list

      val empty_d =  nil
      fun map_d f (d: 'a dict) =  map (fn a => { key = #key a, value = f(#value a) }) d
      fun keys (d: 'a dict) =  (map #key d): set
      fun deref(k, d: 'a dict) =  Option.map #value (List.find (fn a => Eqs.eq(k, #key a)) d)
      fun set_d(k, v, nil) =  [ { key = k, value = v } ]
        | set_d(k, v, a :: (d: 'a dict))
         = if  Eqs.eq(k, #key a)
           then
              a :: d
           else
              a :: set_d(k, v, d)

      val empty_s =  nil
      fun map_s f (s: set) =  map f s
      fun singleton x =  [ x ]
      fun is_member_s(x, s) =  List.exists (fn (y) => Eqs.eq(x, y)) s
      fun drop_s(x, s) =  List.filter (fn (y) => not(Eqs.eq(x, y))) s
      fun insert_s(x, s)
        = if is_member_s(x, s)
          then
             s
          else
             x :: s
      fun union(nil, t) =  t
      | union(x :: s, t) =  insert_s (x, union(s, t))
    fun cut(s, nil) =  s
      | cut(s, y :: t) =  cut(drop_s(y, s), t)
    fun subseteq_s(s, t) =  List.all (fn (x) => is_member_s(x, t)) s

   end;
