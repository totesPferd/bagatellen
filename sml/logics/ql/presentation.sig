use "collections/naming_pointered_type.sig";
use "logics/proof.sig";

signature Presentation =
   sig
      structure Proof: Proof

      structure ModulesBag: NamingPointeredType
      structure QualifierBag: NamingPointeredType

      type state =  {
            equations: Proof.Multi.T
         ,  modules: ModulesBag.PointeredType.ContainerType.T
         ,  qualifier: QualifierBag.PointeredType.ContainerType.T
         ,  typecheck_info: Proof.Multi.T }

      val typecheck: state -> Proof.Multi.T
      val add_module: string -> state -> state
      val add_qualifier: string * string * string -> state -> state Option.option

      val get_normalform: state -> string -> QualifierBag.PointeredType.BaseType.T Option.option
      val ceq: state -> string * string -> bool
   end;
