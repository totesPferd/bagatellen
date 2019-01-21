datatype 'a option =  none | some of 'a;

fun map_o f none =  none
  | map_o f (some x) =  some (f x);

