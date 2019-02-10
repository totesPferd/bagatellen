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

      val get_typecheck_clause: state -> (Contecteds.ContectedLiterals.Single.T * string * string) -> Contecteds.Clauses.Single.T
      val typecheck: state -> (Contecteds.ContectedLiterals.Single.T * string * string) -> Proof.Multi.T
      val add_module: string -> state -> state
      val add_qualifier: string * string * string -> state -> state
      val add_equation: (VariableContexts.VariableContext.T * Literals.Single.T * Literals.Single.T) -> state -> state

      val get_normalform: state -> string -> Qualifier.T Option.option
      val ceq: state -> string * string -> bool
   end;
