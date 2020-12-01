use "general/eq_type.sig";
use "logics/pel/named_type.sig";
use "logics/polymorphic_container_type.sig";

functor PELNamedType(X:
   sig
      structure E: EqType
      structure PCT: PolymorphicContainerType
         where type 'a T =  (string Option.option ref * 'a) list
   end ): PELNamedType =
   struct

      type base_t =  X.E.T
      val eq =  X.E.eq

      type container_t =  base_t X.PCT.T

      fun is_in (x, c)
        = List.exists
             (fn (n, y) => eq(x, y))
             c

      fun subeq (c_1, c_2)
        = List.all (fn (n, x) => is_in (x, c_2)) c_1

      fun adjoin (str, x, c) =  (ref (Option.SOME str), x) :: c

      fun insert (t, nil) =  [ t ]
        | insert ((m, x), ((n, y) :: tl))
        = if eq(x, y)
          then
             (m, y) :: tl
          else
             (n, y) :: (insert ((m, x), tl))

      fun sum (c_1, c_2) =  c_1 @ c_2
      fun union (c_1, c_2)
        = List.foldl insert c_1 c_2

      local
          fun get_name_ref b container
            = Option.map (fn (f, _) => f) (List.find (fn (_, w) => eq(b, w)) (container))
      in
          fun get_name b container =  Option.join (Option.map ! (get_name_ref b container))
          fun set_name (name, b) container =  Option.isSome (Option.map (fn (store) => store := Option.SOME name) (get_name_ref b container))
      end

      fun add x c
         =  if is_in (x, c)
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

