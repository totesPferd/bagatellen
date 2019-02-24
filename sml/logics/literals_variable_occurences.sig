use "collections/occurences.sig";
use "logics/literals.sig";
use "logics/variables.sig";

signature LiteralsVariableOccurences =
   sig
      structure Literals: Literals
      structure Occurences: Occurences

      val get_occurences: Literals.Single.T -> Occurences.occurences
      val multi_get_occurences: Literals.Multi.T -> Occurences.occurences

   end;
