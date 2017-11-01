local Term =  require "logics.ql.Term"

local VariableTerm =  Term:__new()

package.loaded["logics.ql.term.Variable"] =  VariableTerm
local Qualifier =  require "logics.ql.Qualifier"
local String =  require "base.type.String"

function VariableTerm:new(variable_context, variable)
   local retval =  Term.new(self, variable_context)
   retval.variable =  variable
   return retval
end

function VariableTerm:get_sort()
   return self.variable:get_sort()
end

function VariableTerm:get_base_spec()
   return self
end

function VariableTerm:get_qualifier()
   return Qualifier:id_factory(self:get_sort())
end
   
function VariableTerm:get_variable()
   return self
end

function VariableTerm:__eq(other)
   local other_variable_term =  other:get_variable()
   if other_variable_term
   then
      return self.variable == other.variable
        and  self:get_variable_context() == other:get_variable_context()
   else
      return false
   end
end

function VariableTerm:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::ql::term::Variable "))
   indentation:insert(self.variable:get_non_nil_name())
   indentation:insert(String:string_factory(": "))
   indentation:insert(self.variable:get_sort():get_name())
   indentation:insert(String:string_factory(")"))
end

function VariableTerm:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::ql::term::Variable"))
   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   deeper_indentation:insert(self.variable:get_non_nil_name())
   deeper_indentation:insert(String:string_factory(": "))
   deeper_indentation:insert(self.variable:get_sort():get_name())
   deeper_indentation:save()
   indentation:insert(String:string_factory(" )"))
end

return VariableTerm
