use "collections/dictset.sig";
use "collections/occurences.sig";
use "collections/qualified_occurences.sig";
use "general/sum_type.sig";

functor QualifiedOccurences(X:
   sig
      structure Include: Occurences
      structure Qualifier: Occurences
      structure QualifiedBaseType: SumType
      sharing QualifiedBaseType.FstType = Qualifier.DictSet.Eqs
      sharing Include.DictSet.Eqs = QualifiedBaseType
   end ): QualifiedOccurences =
   struct
      open X.Include
      structure Qualifier =  X.Qualifier
      structure QualifiedBaseType =  X.QualifiedBaseType

      val core_singleton =  singleton o QualifiedBaseType.snd_inj
      val import_qualifier
         =  Qualifier.DictSet.Sets.transition
               (  fn (v, occ)
                    => let
                          val s =  singleton(QualifiedBaseType.fst_inj v)
                          val occ' =  unif_occurences (occ, s)
                       in Option.SOME occ'
                       end )
            o Qualifier.get_occurences
   end;
