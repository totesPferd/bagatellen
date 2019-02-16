use "collections/eqs.sig";
use "collections/pointered_type.sig";
use "collections/polymorphic_pointered_type.sig";

functor PointeredType(X:
   sig
      structure B: Eqs
      structure PPT: PolymorphicPointeredType
   end ): PointeredType =
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
      val empty =       X.PPT.empty ()
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
