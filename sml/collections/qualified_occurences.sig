use "collections/occurences.sig";
use "general/sum_type.sig";

signature QualifiedOccurences =
   sig
      include Occurences

      structure Qualifier: Occurences
      structure QualifiedBaseType: SumType
      sharing QualifiedBaseType.FstType = Qualifier.DictSet.Eqs
      sharing DictSet.Eqs = QualifiedBaseType

      val import_qualifier: Qualifier.T -> T -> T
      val core_singleton:   QualifiedBaseType.SndType.T -> T

   end;
      

