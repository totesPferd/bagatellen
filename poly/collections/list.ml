 fun drop_l(x, nil) =  nil
   | drop_l(x, y :: ll)
   = if x = y
     then
        ll
     else
        y :: drop_l(x, ll)
fun is_member_l(x, nil) =  false
  | is_member_l(x, y :: ll)
  = (x = y) orelse is_member_l(x, ll);
fun insert_l(x, nil) =  [x]
  | insert_l(x, y :: ll)
  = if  x = y
    then
       y :: ll
    else
       y :: insert_l(x, ll)
fun subseteq_l(nil, ll) =  true
  | subseteq_l(x :: kl, ll)
  =  is_member_l(x, ll) andalso subseteq_l(kl, ll);
