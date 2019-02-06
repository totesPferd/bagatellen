use "collections/pointer_type.sig";
use "collections/eqs.sig";
use "collections/unit_type.sml";

functor UnitPointerType(B: Eqs): PointerType =
   struct
      structure BaseType =  B
      structure ContainerType =
         struct
            type T =  B.T Option.option
         end
      structure PointerType =  UnitType

      exception NotFound
      fun select(sel, c)
        = case (c) of
             Option.NONE => raise NotFound
          |  Option.SOME b => b

      fun fold f b Option.NONE =  b
        | fold f b (Option.SOME x) =  f(x, b)

      fun map f =  Option.map f

      fun empty () =  Option.NONE
      fun is_empty (c: ContainerType.T) =  not (Option.isSome c)

      fun all P Option.NONE =  true
        | all P (Option.SOME x) = P x

      exception ZipLengthsDoesNotAgree
      fun all_zip P (Option.NONE, Option.NONE) =  true
        | all_zip P (Option.SOME x_1, Option.SOME x_2) =  P(x_1, x_2)
        | all_zip P (Option.NONE, Option.SOME x_2) =  raise ZipLengthsDoesNotAgree
        | all_zip P (Option.SOME x_1, Option.NONE) =  raise ZipLengthsDoesNotAgree

      fun mapfold f g w0 Option.NONE = (Option.NONE, w0)
        | mapfold f g w0 (Option.SOME x) 
        = let
             val x_item = f x
             val next_v = Option.SOME x_item
             val next_w = g(x, x_item, w0)
          in
             (next_v, next_w)
          end

      fun transition phi Option.NONE b =  b
        | transition phi (Option.SOME x) b
        = case(phi (x, b)) of
             Option.NONE =>  b
          |  Option.SOME c => c

      fun fe (x: BaseType.T) =  Option.SOME x
      fun fop phi (c: ContainerType.T) =  Option.join (Option.map phi c)
      fun is_in (x: BaseType.T, c: ContainerType.T)
        = Option.isSome (Option.map (fn (y) => BaseType.eq(x, y)) c)

      exception ResolutionSetDoesNotContainConclusion
      fun replace(x, c) Option.NONE =  raise ResolutionSetDoesNotContainConclusion
        | replace(x, c) (Option.SOME y)
        = if B.eq(x, y)
          then
             c
          else
             raise ResolutionSetDoesNotContainConclusion

   end;
