use "logics/variables.sig";

signature VariableContexts =
   sig
      structure Variables: Variables

      eqtype 'a VariableContext
 
      val new: unit -> 'a VariableContext

      val get_name: 'a Variables.Variable -> 'a VariableContext -> string Option.option
      val set_name: (string * 'a Variables.Variable) -> 'a VariableContext -> bool

   end;
