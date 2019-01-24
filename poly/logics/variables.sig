signature Variables =
   sig
      type Variable
      type VariableContext

      val new_var:      Variable
      val copy_var:     Variable -> Variable
      val eq_var:       Variable * Variable -> bool
      val get_val:      Variable -> 'a Option.option

      val new_val_ctxt: VariableContext
      val contains_var: Variable -> VariableContext -> bool
      val add_var:      Variable -> VariableContext -> unit
      val add_var_ctxt: VariableContext -> VariableContext -> unit
      val is_settable:  Variable -> VariableContext -> bool
      val set_val:      'a -> Variable -> VariableContext -> bool
end;
