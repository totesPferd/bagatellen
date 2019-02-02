use "collections/acc.sml";
use "collections/dictset.sig";
use "collections/eqs.sig";

functor DictSet(E: Eqs): DictSet =
   struct
      structure Eqs =  E
      structure Acc =  Acc

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
      fun all_d P = List.all (fn { key = _, value = v } => P v)
      exception ZipSrcDoesNotAgree
      local
         fun deref_direct(k, d)
           = case (deref(k, d)) of
                Option.NONE =>  raise ZipSrcDoesNotAgree
             |  Option.SOME v => v
      in
         fun zip_d ((a: 'a dict), (b: 'b dict))
           = List.foldl
                (
                   fn ({ key = k, value = v}, d) =>  set_d(k, (v, deref_direct(k, b)), d) )
                (empty_d: ('a * 'b) dict)
                a
      end

      val empty_s =  nil
      fun map_s f (s: set) =  map f s
      fun singleton x =  [ x ]
      fun is_member_s(x, s) =  List.exists (fn (y) => Eqs.eq(x, y)) s
      val is_empty_s =  List.null
      fun drop_s(x, s) =  List.filter (fn (y) => not(Eqs.eq(x, y))) s
      fun drop_if_exists_s(x, s)
        = if is_member_s(x, s)
          then
             Option.SOME (drop_s(x, s))
          else
             Option.NONE
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
    fun eq_s(s, t) =  subseteq_s(s, t) andalso subseteq_s(t, s)

    fun find_s P s =  List.find P s

    fun ofind_s f nil =  Option.NONE
      | ofind_s f (hd :: tl)
      = case(f hd) of
           Option.NONE => ofind_s f tl
        |  Option.SOME y =>  Option.SOME y

    fun transition_s phi s b =  Acc.transition phi s b

   end;
