use "collections/acc.sml";
use "collections/all_zip.sig";
use "collections/naming_pointered_type_generating.sig";
use "collections/naming_polymorphic_container_type.sig";
use "general/eqs.sig";
use "general/type_map.sig";
use "general/type_binary_relation.sig";

functor NamingPointeredTypeGenerating(X:
   sig
      structure BaseType: Eqs
      structure BaseStructureMap: TypeMap
      structure BinaryRelation: TypeBinaryRelation
      structure PolymorphicContainerType: NamingPolymorphicContainerType
      sharing BinaryRelation.Domain = BaseType
      sharing BaseStructureMap.Start = BaseType
      sharing BaseStructureMap.End = BaseType
   end ): NamingPointeredTypeGenerating =
   struct
      structure PolymorphicContainerType =  X.PolymorphicContainerType
      structure PointeredTypeExtended =
         struct
            structure BaseType =  X.BaseType
            structure ContainerType =
               struct
                  type T =  BaseType.T PolymorphicContainerType.T
                  val eq =  X.PolymorphicContainerType.cong BaseType.eq
               end
            structure PointerType =
               struct
                  type T =  string Option.option ref
                  fun eq(x, y) =  (x = y)
               end
            structure BaseStructure =  X.BaseType
            structure BaseStructureMap =  X.BaseStructureMap

            val empty         =  List.nil
            val is_empty      =  List.null
            fun select (n, c)
               =  case (List.find (fn (m, y) => (m = n)) c) of
                     Option.NONE =>  Option.NONE
                  |  Option.SOME (k, v) => Option.SOME v

            fun all P c
              = List.all (fn (n, x) => P x) c

            val all_zip =  PolymorphicContainerType.all_zip

            val base_map =  BaseStructureMap.apply

            fun transition f c =  Acc.transition (fn ((n, x: 'a), y) => f(x, y)) c

            fun is_in (x, c)
              = List.exists
                   (fn (n, y) => BaseType.eq(x, y))
                   c

            fun subeq (c_1, c_2)
              = List.all (fn (n, x) => is_in (x, c_2)) c_1

         end
      structure AllZip =
         struct
            structure BinaryRelation =  X.BinaryRelation
            structure PointeredType =  PointeredTypeExtended

            val result =  PointeredTypeExtended.all_zip o X.BinaryRelation.apply

         end

      fun singleton (p, x) =  [ (p, x) ]


(*
 *
 *)

      fun adjoin (str, x, c) =  (ref (Option.SOME str), x) :: c

      fun insert (t, nil) =  [ t ]
        | insert ((m, x), ((n, y) :: tl))
        = if PointeredTypeExtended.BaseType.eq(x, y)
          then
             (m, y) :: tl
          else
             (n, y) :: (insert ((m, x), tl))

      fun sum (c_1, c_2) =  c_1 @ c_2
      fun union (c_1, c_2)
        = List.foldl insert c_1 c_2


      fun transition f c =  Acc.transition (fn ((n, x), y) => f(!n, x, y)) c

      local
          fun get_name_ref b container
            = Option.map (fn (f, _) => f) (List.find (fn (_, w) => PointeredTypeExtended.BaseType.eq(b, w)) (container))
      in
          fun get_name b container =  Option.join (Option.map ! (get_name_ref b container))
          fun set_name (name, b) container =  Option.isSome (Option.map (fn (store) => store := Option.SOME name) (get_name_ref b container))
      end

      fun add x c
         =  if PointeredTypeExtended.is_in (x, c)
            then
               c
            else
               (ref Option.NONE, x) :: c

      fun uniquize(container)
        = let
             fun rename(do_not_use_list, candidate)
               = if (List.exists (fn (n) => (n = candidate)) do_not_use_list)
                 then
                    rename(do_not_use_list, candidate ^ "'")
                 else
                    candidate
             fun get_candidate name_r
               = (
                    case (!name_r) of
                       Option.NONE => "_"
                    |  Option.SOME n => n )
             fun get_next_do_not_use_list((name_r, b), do_not_use_list)
               = let
                    val new_name =  rename(do_not_use_list, get_candidate name_r)
                 in
                    (
                       name_r := Option.SOME new_name;
                       (new_name :: do_not_use_list) )
                 end;
          in
             (List.foldl (get_next_do_not_use_list) nil container; ())
          end
   end;
