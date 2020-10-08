module FirstDictImpl where

type Dict k v = [( k, v )]

get (( k_1, v ):l, k_2) =
   if (k_1 == k_2)
   then
      v
   else
      get(l, k_2)

set ((p@( k_1, _ )):l, k_2, v) =
   if (k_1 == k_2)
   then
      (k_1, v):l
   else
      p:(set(l, k_2, v))
