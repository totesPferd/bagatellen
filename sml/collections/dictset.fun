use "collections/acc.sml";
use "collections/dictset.sig";
use "general/eqs.sig";

functor DictSet(E: Eqs): DictSet =
   struct
      structure Eqs =  E
      structure Acc =  Acc


      structure Dicts =
         struct
            type 'a dict =  { key: Eqs.T, value: 'a } list
            val empty =  nil
            fun map (f: 'a -> 'b) (d: 'a dict) =  List.map (fn a => { key = #key a, value = f(#value a) }) d
            fun deref(k, d: 'a dict) =  Option.map (#value) (List.find (fn a => Eqs.eq(k, #key a)) d)
            fun set(k, v, nil) =  [ { key = k, value = v } ]
              | set(k, v, a :: (d: 'a dict))
               = if  Eqs.eq(k, #key a)
                 then
                    a :: d
                 else
                    a :: set(k, v, d)
            fun all P = List.all (fn { key = _, value = v } => P v)
            exception ZipSrcDoesNotAgree
            local
               fun deref_direct(k, d)
                 = case (deref(k, d)) of
                      Option.NONE =>  raise ZipSrcDoesNotAgree
                   |  Option.SOME v => v
            in
               fun zip ((a: 'a dict), (b: 'b dict))
                 = List.foldl
                      (
                         fn ({ key = k, value = v}, d) =>  set(k, (v, deref_direct(k, b)), d) )
                      (empty: ('a * 'b) dict)
                      a
            end
            fun adjoin(d_1, d_2) =  d_1 @ d_2
         end

      structure Sets =
         struct
            type T =  Eqs.T list
            val empty =  nil
            val getItem =  List.getItem
            fun map f (s: T) =  map f s
            fun singleton x =  [ x ]
            fun is_in(x, s) =  List.exists (fn (y) => Eqs.eq(x, y)) s
            val is_empty =  List.null
            fun adjunct(x, s) =  x :: s
            fun drop(x, s) =  List.filter (fn (y) => not(Eqs.eq(x, y))) s
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
            fun eq(s, t) =  subseteq(s, t) andalso subseteq(t, s)
        
            fun find P s =  List.find P s
        
            fun ofind f nil =  Option.NONE
              | ofind f (hd :: tl)
              = case(f hd) of
                   Option.NONE => ofind f tl
                |  Option.SOME y =>  Option.SOME y
        
            fun fe b =  [ b ]
            fun transition phi s b =  Acc.transition phi s b
            fun fop phi s
              = transition (
                   fn (x, b) => Option.SOME (union (phi x, b)) )
                s
                nil
         end
  
      fun keys (d: 'a Dicts.dict) =  (map #key d): Sets.T
   end;
