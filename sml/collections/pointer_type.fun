use "collections/eqs.sig";
use "collections/pointer_type.sig";
use "collections/polymorphic_pointer_type.sig";

functor PointerType(X:
   sig
      structure B: Eqs
      structure PPT: PolymorphicPointerType
   end ): PointerType =
   struct
      structure BaseType = X.B
      structure PointerType = X.PPT.PointerType
      structure ContainerType =
         struct
            type T =  X.B.T X.PPT.ContainerType.T
         end
      val select =      X.PPT.select

      val fold =        X.PPT.fold
      val map =         X.PPT.map
      val empty =       X.PPT.empty
      val is_empty =    X.PPT.is_empty
      val all =         X.PPT.all
      val all_zip =     X.PPT.all_zip

      val mapfold =     X.PPT.mapfold

      val fe =          X.PPT.fe
      val fop =         X.PPT.p_fop X.B.eq
      val is_in =       X.PPT.p_is_in X.B.eq
      val subeq =       X.PPT.p_subeq X.B.eq

      val transition =  X.PPT.transition

   end;
