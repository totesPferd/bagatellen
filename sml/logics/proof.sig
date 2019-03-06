use "general/type.sig";
use "logics/constructors.sig";
use "logics/contecteds.sig";

signature Proof =
   sig
      structure Constructors: Constructors
      structure Contecteds: Contecteds
      structure Single: Type
      structure Multi: Type
      sharing Contecteds.Clauses.Single =  Single

      val apply:                      Contecteds.Literals.PointerType.T -> Multi.T -> Contecteds.Clauses.Single.T -> Contecteds.Clauses.Multi.T
      val multi_apply:                Multi.T -> Contecteds.Clauses.Multi.T -> Contecteds.Clauses.Multi.T
      val apply_conventionally:       Contecteds.Literals.PointerType.T -> Multi.T -> Contecteds.Clauses.Single.T -> Contecteds.Clauses.Multi.T
      val multi_apply_conventionally: Multi.T -> Contecteds.Clauses.Multi.T -> Contecteds.Clauses.Multi.T
      val add_clause_to_proof:        Contecteds.Clauses.Single.T * Multi.T -> Multi.T
      val add_multi_clause_to_proof:  Contecteds.Clauses.Multi.T * Multi.T -> Multi.T
      val combine_proofs:             Multi.T * Multi.T -> Multi.T

      val mini_complete:              Multi.T -> Multi.T
      val reduce_double_occurences:   Multi.T -> Multi.T

      val fe:                         Single.T -> Multi.T
      val fop:                        (Single.T -> Multi.T) -> Multi.T -> Multi.T
      val is_in:                      Single.T * Multi.T -> bool

      val transition:                 (Single.T * 'b -> 'b Option.option) -> Multi.T -> 'b -> 'b

   end;
