use "collections/acc.sml";
use "collections/naming_pointered_type_generating.sig";
use "collections/naming_polymorphic_container_type.sig";
use "general/eqs.sig";

functor NamingPointeredTypeGenerating(X:
   sig
      structure BaseType: Eqs
      structure PolymorphicContainerType: NamingPolymorphicContainerType
   end ): NamingPointeredTypeGenerating =
   struct
      structure PolymorphicContainerType =  X.PolymorphicContainerType
      structure PointeredType =
         struct
            structure BaseType =  X.BaseType
            structure ContainerType =
               struct
                  type T =  BaseType.T PolymorphicContainerType.T
                  val eq = ListPair.all (fn ((m, x), (n, y)) => BaseType.eq (x, y))
               end
            structure PointerType =
               struct
                  type T =  string Option.option ref
               end
      
            val empty         =  List.nil
            val is_empty      =  List.null
            fun select (n, c)
               =  case (List.find (fn (m, y) => (m = n)) c) of
                     Option.NONE =>  Option.NONE
                  |  Option.SOME (k, v) => Option.SOME v

            fun all P c
              = List.all (fn (n, x) => P x) c
      
            fun all_zip P (c_1, c_2)
              = List.all
                   (fn ((n_1, x_1), (n_2, x_2)) => P(x_1, x_2))
                   (ListPair.zip (c_1, c_2))
      
            fun map phi c
              = (List.map (fn (n, x) => (n, phi x)) c)

            fun filter P c
               =  Acc.transition
                  (   fn ((n, x: 'a), y)
                      => Option.SOME (
                            if P x
                            then
                               (n, x) :: y
                            else
                               y ))
                   c
                   nil
      
            fun transition f c =  Acc.transition (fn ((n, x: 'a), y) => f(x, y)) c
      
            fun insert (t, nil) =  [ t ]
              | insert ((m, x), ((n, y) :: tl))
              = if BaseType.eq(x, y)
                then
                   (m, y) :: tl
                else
                   (n, y) :: (insert ((m, x), tl))
      
            fun union (c_1, c_2)
              = List.foldl insert c_1 c_2
      
            fun sum (c_1, c_2) =  c_1 @ c_2
      
            fun fe x =  [ (ref Option.NONE, x) ]
            fun fop phi c
              = transition (
                      fn (x, c')
                       => Option.SOME (union (phi x, c')) )
                      c
                      nil
            fun is_in (x, c)
              = List.exists
                   (fn (n, y) => BaseType.eq(x, y))
                   c
      
            fun subeq (c_1, c_2)
              = List.all (fn (n, x) => is_in (x, c_2)) c_1

         end

         fun singleton (p, x) =  [ (p, x) ]

   end;
