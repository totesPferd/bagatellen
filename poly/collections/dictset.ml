use "collections/list.ml";
use "collections/option.ml";

abstype ('a, 'b) dict =  dict of ('a * 'b) list
    and 'a set =  set of 'a list
with
    val empty_d =  dict nil
    fun map_d f (dict kl) =  dict (map (fn (k, v) => (k, f(v))) kl)
    fun keys (set kd) =  set (map (fn (k, v) => k) kd)
    fun deref(k, dict nil) =  none
      | deref(k, dict ((f, v) :: ll))
      = if  k = f
        then
           some v
        else
           deref(k, dict ll)
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

    fun deref_r(k, ref_d) =  map_o ! (deref(k, !ref_d))
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

    val empty_s =  set nil
    fun singleton_s(x) =  set [ x ]
    fun is_member_s(x, set ll) =  is_member_l(x, ll)
    fun drop_s(x, set ll) =  set(drop_l(x, ll))
    fun insert_s(x, set ll) =  set(insert_l(x, ll))
    fun union(set nil, ls) =  ls
      | union(set (x :: kl), ls) =  insert_s (x, union(set kl, ls))
    fun cut(ks, set nil) =  ks
      | cut(ks, set(y :: ll)) =  cut(drop_s(y, ks), set ll)
    fun subseteq_s(set kl, set ll) =  subseteq_l(kl, ll)
    fun map_s f (set kl) =  set (map f kl)
end;
