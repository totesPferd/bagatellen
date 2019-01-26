abstype ('a, 'b) dict =  dict of ('a * 'b) list
    and 'a set =  set of 'a list
with
    val empty_d =  dict nil
    fun map_d f (dict kl) =  dict (map (fn (k, v) => (k, f(v))) kl)
    fun keys (set kd) =  set (map (fn (k, v) => k) kd)
    fun deref(k, dict ll) =  Option.map (fn (f, v) => v) (List.find (fn (f, v) => (k = f)) ll)
    fun rev_deref(v, dict ll) =  Option.map (fn (f, v) => f) (List.find (fn (f, w) => (v = w)) ll)
    local
       fun lset(k, v, nil) =  [(k, v)]
         | lset(k, v, ((f, w) :: ll))
         = if  k = f
           then
              (f, v) :: ll
           else
              (f, v) :: lset(k, v, ll)
    in
       fun set_d (k, v, dict ll) =  dict(lset(k, v, ll))
    end

    fun deref_r(k, ref_d) =  Option.map ! (deref(k, !ref_d))
    fun rev_deref_r(v, ref_d) =  (rev_deref(v, !ref_d))
    local
       fun lset_r(k, v, nil)
         = let
              val store =  ref(v)
           in
              [ (k, store) ]
           end
         | lset_r(k, v, ((f, store) :: lstore))
         = if  k = f
           then (
              store :=  v;
              (f, store) :: lstore )
           else
              (f, store) :: lset_r(k, v, lstore)
       fun dset_r(k, v, dict ll) =  dict(lset_r(k, v, ll))
    in
       fun set_r(k, v, dstore)
         = dstore :=  dset_r(k, v, !dstore);
    end
    fun update_r(k, v, dstore) =  Option.isSome (Option.map (fn(store) => store := v) (deref(k, !dstore)))

    val empty_s =  set nil
    fun singleton_s(x) =  set [ x ]
    fun is_member_s(x, set ll) =  List.exists (fn (y) => x = y) ll
    fun drop_s(x, set ll) =  set(List.filter (fn (y) => not(x = y)) ll)
    fun insert_s(x, set ll)
      = set(
           if is_member_s(x, set ll)
           then
              ll
           else
              x :: ll )
    fun union(set nil, ls) =  ls
      | union(set (x :: kl), ls) =  insert_s (x, union(set kl, ls))
    fun cut(ks, set nil) =  ks
      | cut(ks, set(y :: ll)) =  cut(drop_s(y, ks), set ll)
    fun subseteq_s(ks, ls) =  List.all (fn (x) => is_member_s(x, ls)) ks
    fun map_s f (set kl) =  set (map f kl)
end;
