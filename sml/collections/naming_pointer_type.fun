use "collections/acc.sml";
use "collections/eqs.sig";
use "collections/pointer_type.sig";
use "collections/string_type.sml";

functor NamingPointerType(B: Eqs) =
   struct
      structure Acc =  Acc
      structure BaseType =  B
      structure ContainerType =
         struct
            type T =  (string Option.option ref * B.T) list
         end
      structure PointerType =  StringType

      exception NotFound
      fun select(sel: PointerType.T, c: ContainerType.T)
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

      fun fold f b (c: ContainerType.T)
        = List.foldl (fn ((_, a), x) =>  f(a, x)) b c

      fun map (phi: BaseType.T -> BaseType.T) (c: ContainerType.T)
        = (List.map (fn (n, x) => (ref (!n), phi x)) c): ContainerType.T

      fun empty() =  nil
      fun is_empty (c: ContainerType.T) =  (List.null c)

      fun all (P: BaseType.T -> bool) (c: ContainerType.T)
        = List.all (fn (n, x) => P x) c

      fun all_zip (P: BaseType.T * BaseType.T -> bool) (c_1: ContainerType.T, c_2: ContainerType.T)
        = List.all
             (fn ((n_1, x_1), (n_2, x_2)) => P(x_1, x_2))
             (ListPair.zip (c_1, c_2))

      local
         fun mapfold_item f g ((name_r: string Option.option ref, x: BaseType.T), (v: ContainerType.T, w))
           = let
                val x_item =  f x
                val nx_item =  (ref (!name_r), x_item)
                val next_v =  nx_item :: v
                val next_w =  g(x, x_item, w)
             in
                (next_v, next_w)
             end
      in fun mapfold f g w0 c
           = List.foldl (mapfold_item f g) (nil, w0) (c: ContainerType.T)
      end
             
      fun transition f (c: ContainerType.T) =  Acc.transition (fn ((n, x: BaseType.T), y) => f(x, y)) c

      fun insert (t, nil) =  [ t ]
        | insert ((m, x), ((n, y) :: tl))
        = if B.eq(x, y)
          then
             (m, y) :: tl
          else
             (n, y) :: (insert ((m, x), tl))

      fun union (c_1: ContainerType.T, c_2: ContainerType.T)
        = List.foldl insert c_1 c_2

      exception ResolutionSetDoesNotContainConclusion
      fun replace(x, c) nil =  raise ResolutionSetDoesNotContainConclusion
        | replace(x, c: ContainerType.T) (((n, y) :: tl): ContainerType.T)
        = if B.eq(x, y)
          then
             union (c, tl)
          else
             (n, y) :: (replace(x, c) tl)


(*
 *
 *)

      val new =  nil: ContainerType.T

      local
          fun get_name_ref b container
            = Option.map (fn (f, _) => f) (List.find (fn (_, w) => B.eq(b, w)) (container))
      in
          fun get_name b (container: ContainerType.T) =  Option.join (Option.map ! (get_name_ref b container))
          fun set_name (name, b) (container: ContainerType.T) =  Option.isSome (Option.map (fn (store) => store := Option.SOME name) (get_name_ref b container))
      end

      fun uniquize(container: ContainerType.T)
        = let
             fun rename(do_not_use_list, candidate)
               = if (List.exists (fn (n) => (n = candidate)) do_not_use_list)
                 then
                    rename(do_not_use_list, candidate ^ "'")
                 else
                    candidate
             fun get_candidate(name_r, b)
               = (
                    case (!name_r) of
                       Option.NONE => "x"
                    |  Option.SOME n => n )
             fun get_next_do_not_use_list((name_r, b), do_not_use_list)
               = let
                    val new_name =  rename(do_not_use_list, get_candidate(name_r, b))
                 in
                    (
                       name_r := Option.SOME new_name;
                       (new_name :: do_not_use_list) )
                 end;
          in
             (List.foldl (get_next_do_not_use_list) nil container; ())
          end
   end;
