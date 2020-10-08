use "general/pair_type.sig";
use "general/type.sig";

functor PairType(X:
   sig
      structure FstType: Type
      structure SndType: Type
   end ): PairType =
   struct
      structure FstType =  X.FstType
      structure SndType =  X.SndType

      type T =  FstType.T * SndType.T

      fun fst (x, y) =  x
      fun snd (x, y) =  y
      fun tuple(x, y) =  (x, y)

   end;
