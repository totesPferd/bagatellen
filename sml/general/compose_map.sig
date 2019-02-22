use "general/map.sig";

signature ComposeMap =
   sig
      structure A: Map
      structure B: Map
      structure Result: Map
      sharing A.Start = Result.Start
      sharing A.End = B.Start
      sharing B.End = Result.End

      val compose: A.T * B.T -> Result.T

   end;

