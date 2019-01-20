use "collections/list.ml";

abstype 'a set =  set of 'a list
with
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
end;
