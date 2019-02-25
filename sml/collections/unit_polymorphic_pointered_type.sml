use "collections/polymorphic_pointered_type.sig";
use "collections/unit_type.sml";

structure UnitPolymorphicPointeredType =
   struct
      structure ContainerType =
         struct
            type 'a T =  'a Option.option
            fun polymorphic_eq (eq) (Option.NONE, Option.NONE) =  true
              | polymorphic_eq (eq) (Option.SOME _, Option.NONE) =  false
              | polymorphic_eq (eq) (Option.NONE, Option.SOME _) = false
              | polymorphic_eq (eq) (Option.SOME x, Option.SOME y) =  eq (x, y)
         end
      structure PointerType =  UnitType

      fun select(sel, c) =  c

      fun map f =  Option.map f

      fun empty () =  Option.NONE
      fun is_empty (c: 'a ContainerType.T) =  not (Option.isSome c)

      fun all P Option.NONE =  true
        | all P (Option.SOME x) = P x

      exception ZipLengthsDoesNotAgree
      fun all_zip P (Option.NONE, Option.NONE) =  true
        | all_zip P (Option.SOME x_1, Option.SOME x_2) =  P(x_1, x_2)
        | all_zip P (Option.NONE, Option.SOME x_2) =  raise ZipLengthsDoesNotAgree
        | all_zip P (Option.SOME x_1, Option.NONE) =  raise ZipLengthsDoesNotAgree

      fun filter P Option.NONE =  Option.NONE
      |   filter P (Option.SOME x)
         =  if P x
            then Option.SOME x
            else Option.NONE

      fun transition phi Option.NONE b =  b
        | transition phi (Option.SOME x) b
        = case(phi (x, b)) of
             Option.NONE =>  b
          |  Option.SOME c => c

      val fe =  Option.SOME
      fun p_fop (eq) phi (c: 'a ContainerType.T) =  Option.join (Option.map phi c)
      fun p_is_in (eq: 'a * 'a -> bool) (x: 'a, c: 'a ContainerType.T)
        = Option.isSome (Option.map (fn (y) => eq(x, y)) c)

      fun p_subeq (eq: 'a * 'a -> bool) (c_1: 'a ContainerType.T, c_2: 'a ContainerType.T)
        = case(c_1) of
             Option.NONE => true
          |  Option.SOME x => p_is_in (eq) (x, c_2)

(*
 *
 *)

      fun singleton (p, x) =  Option.SOME x

   end;
