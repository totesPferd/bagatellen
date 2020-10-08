use "collections/string_type.sig";
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

      structure QualifierPointer: StringType

      type state

      val get_typecheck_clause:
            Literals.PointerType.T * Literals.PointerType.T * Literals.PointerType.T
         -> state
         -> (Contecteds.ContectedLiterals.Single.T * string * string)
         -> Contecteds.Clauses.Single.T Option.option
      val typecheck:
            Literals.PointerType.T * Literals.PointerType.T * Literals.PointerType.T * Literals.PointerType.T
         -> state
         -> (Contecteds.ContectedLiterals.Single.T * string * string)
         -> Contecteds.Clauses.Multi.T Option.option
      val add_module: string -> state -> state
      val add_qualifier:
            Literals.PointerType.T * Literals.PointerType.T * Literals.PointerType.T * Literals.PointerType.T
         -> string * string * string
         -> state
         -> state
      val add_equation:
            Literals.PointerType.T * Literals.PointerType.T * QualifierPointer.T
         -> (VariableContexts.VariableContext.T * Literals.Single.T * Literals.Single.T)
         -> state
         -> state

      val get_normalform: Literals.PointerType.T -> state -> (Contecteds.ContectedLiterals.Single.T) -> Contecteds.Clauses.Multi.T
      val ceq: Literals.PointerType.T -> state -> (VariableContexts.VariableContext.T * Literals.Single.T * Literals.Single.T) -> bool

      val seqset: Contecteds.ContectedLiterals.Single.T * Contecteds.ContectedLiterals.Single.T -> Contecteds.ContectedLiterals.Single.T Option.option

      val get_constructors_name: state -> QLConstructors.T -> string

   end;
