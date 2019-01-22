use "collections/option.ml";

signature Variables =
   sig
      type Literal
      type Variable
      type VariableContext

      val new_var:      Variable ref
      val copy_var:     Variable ref -> Variable ref
      val get_val:      Variable ref -> Literal option

      val new_val_ctxt: VariableContext ref
      val contains_var: Variable ref -> VariableContext ref -> bool
      val add_var:      Variable ref -> VariableContext ref -> unit
      val add_var_ctxt: VariableContext ref -> VariableContext ref -> unit
      val is_settable:  Variable ref -> VariableContext ref -> bool
      val set_val:      Literal -> Variable ref -> VariableContext ref -> bool
end;
