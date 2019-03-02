signature DoublePolymorphicContainerType =
   sig
      structure Fst:
         sig
            type 'a T
         end
      structure Snd:
         sig
            type 'a T
         end

      type 'a T =  'a Fst.T * 'a Snd.T

   end;
