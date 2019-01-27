use "collections/type.sig";
use "logics/variables.sig";

functor Variables(B: Type): Variables =
   struct
      structure Base = B

      structure Variable =
         struct
            type T =  B.T Option.option ref
         end

      fun new () =  ref Option.NONE

      fun get_val var_store =  !var_store
      fun copy var_store =  ref(get_val var_store)

      fun eq (x, y) =  (x = y)

      fun is_settable var_store =  not(Option.isSome(get_val var_store))
      fun set_val value var_store
        = let
             val retval =  is_settable var_store
          in
             if  retval
             then (
                var_store := Option.SOME value;
                retval )
             else
                retval
          end
   end;
