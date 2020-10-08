use "general/dict_set.sig";
use "general/eq_type.sig";
use "general/set.sig";

functor Set(X:
   sig

      structure K: EqType

      structure I: DictSet
      sharing I.E = K

   end ): Set =
   struct

      structure Implementation =  X.I

      type base_t =  X.K.T
      type T = X.I.Sets.T

      val adjunct        = X.I.Sets.adjunct
      val cut            = X.I.Sets.cut
      val drop_if_exists = X.I.Sets.drop_if_exists
      val drop           = X.I.Sets.drop
      val empty          = X.I.Sets.empty
      val eq             = X.I.Sets.eq
      val getItem        = X.I.Sets.getItem
      val insert         = X.I.Sets.insert
      val intersect      = X.I.Sets.intersect
      val is_empty       = X.I.Sets.is_empty
      val map            = X.I.Sets.map
      val singleton      = X.I.Sets.singleton
      val subseteq       = X.I.Sets.subseteq
      val sum            = X.I.Sets.sum
      val union          = X.I.Sets.union

      val find           = X.I.Sets.find

      val ofind          = X.I.Sets.ofind

      val fe             = X.I.Sets.fe
      val fop            = X.I.Sets.fop
      val is_in          = X.I.Sets.is_in
      val transition     = X.I.Sets.transition

   end
