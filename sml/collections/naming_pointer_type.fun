use "collections/eqs.sig";
use "collections/pointer_type.sig";
use "collections/string_type.sml";

functor NamingPointerType(B: Eqs) =
   struct
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
