use "general/dict_keys.sig";
use "general/eq_type.sig";
use "general/subeq_type.sig";

functor SubeqTypeForDict(X:
   sig
      structure DictKeys: DictKeys
      structure ValEqType: EqType
         where type T =  DictKeys.From.val_t
   end ): SubeqType =
   struct

      type T =  X.DictKeys.From.T

      fun subeq(t_a, t_b) =
         let
            val keys =  X.DictKeys.keys t_a
         in
            X.DictKeys.To.transition (
               fn (k, s) =>
                  let
                     val v_a =  Option.valOf (X.DictKeys.From.deref (k, t_a))
                     val vo_b =  X.DictKeys.From.deref(k, t_b)
                  in
                     case vo_b of
                           Option.NONE => false
                        |  Option.SOME v_b =>  X.ValEqType.eq(v_a, v_b) andalso s()
                  end )
               keys
               true
         end

   end;
