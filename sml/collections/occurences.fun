use "collections/dictset.sig";
use "collections/occurences.sig";

functor Occurences(X: DictSet): Occurences =
   struct
      structure DictSet =  X

      type occurences =  {
            multiple_occ: DictSet.Sets.T
         ,  occ: DictSet.Sets.T }

      fun get_multiple_occurences ({ multiple_occ = A, occ = _ }: occurences) =  A
      fun get_occurences ({ multiple_occ = _, occ = B }: occurences) =  B

      val empty =  { multiple_occ =  DictSet.Sets.empty, occ =  DictSet.Sets.empty }: occurences
      fun singleton x =  { multiple_occ =  DictSet.Sets.empty, occ = DictSet.Sets.singleton x }: occurences
      fun unif_occurences ({ multiple_occ = A_1, occ = B_1 }: occurences, { multiple_occ = A_2, occ = B_2 }: occurences)
         =  {  multiple_occ
               =  DictSet.Sets.union(DictSet.Sets.union(A_1, A_2), DictSet.Sets.intersect(B_1, B_2))
            ,  occ =  DictSet.Sets.union(B_1, B_2) }: occurences

   end;
