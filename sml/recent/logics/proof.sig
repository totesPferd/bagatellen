signature Proof =
   sig
      type clause_t
      type multi_clause_t
      type proof_t

      val add_clause_to_proof: clause_t
             -> proof_t -> proof_t
      val add_multi_clause_to_proof:
                multi_clause_t
             -> proof_t -> proof_t

      val apply:
                proof_t
             -> clause_t -> multi_clause_t
      val apply_conventional:
                proof_t
             -> clause_t -> multi_clause_t
      val multi_apply:
                proof_t
             -> multi_clause_t -> multi_clause_t

      val combine_proofs: proof_t * proof_t -> proof_t
      val fe: clause_t -> proof_t
      val fop: (clause_t -> proof_t) -> proof_t -> proof_t
      val is_in: clause_t * proof_t -> bool
      val transition:
                (clause_t * (unit -> 'b) -> 'b)
             -> proof_t
             -> 'b
             -> 'b

      val mini_complete: proof_t -> proof_t
      val reduce_double_occurences: proof_t -> proof_t

   end
