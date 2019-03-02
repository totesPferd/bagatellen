use "collections/double_polymorphic_container_type.sig";

functor DoublePolymorphicContainerType(X:
   sig
      structure Fst:
         sig
            type 'a T
         end
      structure Snd:
         sig
            type 'a T
         end
   end ): DoublePolymorphicContainerType =
   struct
      structure Fst =  X.Fst
      structure Snd =  X.Snd

      type 'a T =  'a Fst.T * 'a Snd.T

   end;
