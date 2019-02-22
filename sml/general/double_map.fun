use "general/map.sig";

functor DoubleMap(X:
   sig
      structure FstMap: Map
      structure SndMap: Map
   end ): Map =
   struct
      structure Start =
         struct
            structure FstStruct =  X.FstMap.Start
            structure SndStruct =  X.SndMap.Start
         end
      structure End =
         struct
            structure FstStruct =  X.FstMap.End
            structure SndStruct =  X.SndMap.End
         end

      type T =  X.FstMap.T * X.SndMap.T

   end;
