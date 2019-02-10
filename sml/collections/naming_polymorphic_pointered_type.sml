use "collections/acc.sml";
use "collections/string_type.sml";

structure NamingPolymorphicPointeredType =
   struct
      structure Acc =  Acc
      structure ContainerType =
         struct
            type 'a T =  (string Option.option ref * 'a) list
            fun polymorphic_eq (eq)
              = ListPair.all (fn ((m, x), (n, y)) => eq (x, y)) 
         end
      structure PointerType =  StringType

      exception NotFound
      fun select(sel: PointerType.T, c: 'a ContainerType.T)
        = let
             fun is_found(s, b)
               = case(!s) of
                    Option.NONE =>  false
                 |  Option.SOME x => (sel = x)
             val found =  List.find is_found c
          in
             case (found) of
                Option.NONE =>  raise NotFound
             |  Option.SOME (_, b) =>  b
          end

      fun fold f b (c: 'a ContainerType.T)
        = List.foldl (fn ((_, a), x) =>  f(a, x)) b c

      fun map (phi: 'a -> 'a) (c: 'a ContainerType.T)
        = (List.map (fn (n, x) => (ref (!n), phi x)) c): 'a ContainerType.T

      fun empty() =  nil
      fun is_empty (c: 'a ContainerType.T) =  (List.null c)

      fun all (P: 'a -> bool) (c: 'a ContainerType.T)
        = List.all (fn (n, x) => P x) c

      fun all_zip (P: 'a * 'a -> bool) (c_1: 'a ContainerType.T, c_2: 'a ContainerType.T)
        = List.all
             (fn ((n_1, x_1), (n_2, x_2)) => P(x_1, x_2))
             (ListPair.zip (c_1, c_2))

      local
         fun mapfold_item f g ((name_r: string Option.option ref, x: 'a), (v: 'a ContainerType.T, w))
           = let
                val x_item =  f x
                val nx_item =  (ref (!name_r), x_item)
                val next_v =  nx_item :: v
                val next_w =  g(x, x_item, w)
             in
                (next_v, next_w)
             end
      in fun mapfold f g w0 c
           = List.foldl (mapfold_item f g) (nil, w0) (c: 'a ContainerType.T)
      end
             
      fun transition f (c: 'a ContainerType.T) =  Acc.transition (fn ((n, x: 'a), y) => f(x, y)) c

      fun p_insert (eq) (t, nil) =  [ t ]
        | p_insert (eq) ((m, x), ((n, y) :: tl))
        = if eq(x, y)
          then
             (m, y) :: tl
          else
             (n, y) :: (p_insert (eq) ((m, x), tl))

      fun p_union (eq) (c_1: 'a ContainerType.T, c_2: 'a ContainerType.T)
        = List.foldl (p_insert (eq)) c_1 c_2

      fun fe (x: 'a) =  [ (ref Option.NONE, x) ]
      fun p_fop (eq) phi (c: 'a ContainerType.T)
        = transition (
                fn (x: 'a, c': 'a ContainerType.T)
                 => Option.SOME (p_union (eq) (phi x, c')) )
                c
                nil
      fun p_is_in (eq: 'a * 'a -> bool) (x: 'a, c: 'a ContainerType.T)
        = List.exists
             (fn (n, y) => eq(x, y))
             c

      fun p_subeq (eq: 'a * 'a -> bool) (c_1: 'a ContainerType.T, c_2: 'a ContainerType.T)
        = List.all (fn (n, x) => p_is_in (eq) (x, c_2)) c_1


(*
 *
 *)

      local
          fun p_get_name_ref (eq) b container
            = Option.map (fn (f, _) => f) (List.find (fn (_, w) => eq(b, w)) (container))
      in
          fun p_get_name (eq) b (container: 'a ContainerType.T) =  Option.join (Option.map ! (p_get_name_ref (eq) b container))
          fun p_set_name (eq) (name, b) (container: 'a ContainerType.T) =  Option.isSome (Option.map (fn (store) => store := Option.SOME name) (p_get_name_ref (eq) b container))
      end

      fun uniquize(container: 'a ContainerType.T)
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
