use "general/pair.sig";
use "general/type.sig";

functor Pair(X:
   sig
      structure FstType: Type
      structure SndType: Type
   end ): Pair =
   struct
      structure FstType =  X.FstType
      structure SndType =  X.SndType

      type T =  FstType.T * SndType.T

      fun fst (x, y) =  x
      fun snd (x, y) =  y
      fun tuple(x, y) =  (x, y)

   end;
