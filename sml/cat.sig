signature Cat =
   sig

      type category_t
      type functor_t
      type natural_transformation_t

      type morphism_t
      type object_t

      val  dm: morphism_t -> category_t
      val  dob: object_t -> category_t
      val  dm0: morphism_t -> object_t
      val  dm1: morphism_t -> object_t

      val  df0: functor_t -> category_t
      val  df1: functor_t -> category_t

      val  dnt0: natural_transformation_t -> functor_t
      val  dnt1: natural_transformation_t -> functor_t

      val  idm: object_t -> morphism_t
      val  cm: morphism_t * morphism_t -> morphism_t

      val  idf: category_t -> functor_t
      val  cf: functor_t * functor_t -> functor_t
      val  appfo: object_t * functor_t -> object_t
      val  appfm: morphism_t * functor_t -> morphism_t

      val  idnt: functor_t -> natural_transformation_t
      val  cmnt: natural_transformation_t * natural_transformation_t -> natural_transformation_t
      val  cfnt: natural_transformation_t * natural_transformation_t -> natural_transformation_t
      val  rfnt: natural_transformation_t * morphism_t -> morphism_t
      val  appnto: object_t * natural_transformation_t -> morphism_t

   end;
