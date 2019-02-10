use "logics/proof.sig";
use "logics/ql/qualifier.sig";

signature Presentation =
   sig
      structure Proof: Proof
      structure Qualifier: Qualifier

      structure ModulesBag: NamingPointeredType
      structure QualifierBag: NamingPointeredType

      type state

      val typecheck: state -> Proof.Multi.T
      val add_module: string -> state -> state
      val add_qualifier: string * string * string -> state -> state Option.option

      val get_normalform: state -> string -> Qualifier.T Option.option
      val ceq: state -> string * string -> bool
   end;
