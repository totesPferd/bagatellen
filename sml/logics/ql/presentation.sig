use "logics/contecteds.sig";
use "logics/literals.sig";
use "logics/proof.sig";
use "logics/variable_contexts.sig";
use "logics/ql/constructors.sig";
use "logics/ql/qualifier.sig";

signature Presentation =
   sig
      structure Contecteds: Contecteds
      structure QLConstructors: QLConstructors
      structure Literals: Literals
      structure Proof: Proof
      structure Qualifier: Qualifier
      structure VariableContexts: VariableContexts
      sharing Contecteds.Constructors =  QLConstructors
      sharing Contecteds.Literals =  Literals
      sharing Contecteds.VariableContexts =  VariableContexts
      sharing Literals.Constructors =  QLConstructors
      sharing QLConstructors.Qualifier =  Qualifier
      sharing Proof.Constructors =  QLConstructors
      sharing Proof.Contecteds =  Contecteds

      type state

      val get_typecheck_clause: state -> (Contecteds.ContectedLiterals.Single.T * string * string) -> Contecteds.Clauses.Single.T Option.option
      val typecheck: state -> (Contecteds.ContectedLiterals.Single.T * string * string) -> Contecteds.Clauses.Multi.T Option.option
      val add_module: string -> state -> state
      val add_qualifier: string * string * string -> state -> state
      val add_equation: (VariableContexts.VariableContext.T * Literals.Single.T * Literals.Single.T) -> state -> state

      val get_normalform: state -> (Contecteds.ContectedLiterals.Single.T) -> Contecteds.Clauses.Multi.T
      val ceq: state -> (VariableContexts.VariableContext.T * Literals.Single.T * Literals.Single.T) -> bool

      val seqset: Contecteds.ContectedLiterals.Single.T * Contecteds.ContectedLiterals.Single.T -> Contecteds.ContectedLiterals.Single.T Option.option

   end;
