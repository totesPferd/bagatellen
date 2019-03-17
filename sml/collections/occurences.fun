use "collections/dictset.sig";
use "collections/occurences.sig";

functor Occurences(X: DictSet): Occurences =
   struct
      structure DictSet =  X

      type T =  {
            multiple_occ: DictSet.Sets.T
         ,  occ: DictSet.Sets.T }

      fun get_multiple_occurences ({ multiple_occ = A, occ = _ }: T) =  A
      fun get_occurences ({ multiple_occ = _, occ = B }: T) =  B

      val empty =  { multiple_occ =  DictSet.Sets.empty, occ =  DictSet.Sets.empty }: T
      fun singleton x =  { multiple_occ =  DictSet.Sets.empty, occ = DictSet.Sets.singleton x }: T
      fun unif_occurences ({ multiple_occ = A_1, occ = B_1 }: T, { multiple_occ = A_2, occ = B_2 }: T)
         =  {  multiple_occ
               =  DictSet.Sets.union(DictSet.Sets.union(A_1, A_2), DictSet.Sets.intersect(B_1, B_2))
            ,  occ =  DictSet.Sets.union(B_1, B_2) }: T

   end;
