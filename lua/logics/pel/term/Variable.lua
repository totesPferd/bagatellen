local Term =  require "logics.pel.Term"

local VariableTerm =  Term:__new()

package.loaded["logics.pel.term.Variable"] =  VariableTerm

function VariableTerm:new(variable_spec, variable)
   local retval =  VariableTerm:__new()
   retval.variable_spec =  variable_spec
   retval.variable =  variable
   return retval
end

function VariableTerm:get_sort()
   return self.variable:get_sort()
end
   
function VariableTerm:get_variable()
   return self
end

function VariableTerm:get_substituted(substitution)
   return substitution:deref(self.variable)
end

function VariableTerm:_aux_unif(substitution, term)
   return substitution:assign_once(self.variable, term)
end

function VariableTerm:__eq(other)
   local other_variable_term =  other:get_variable()
   if other_variable_term
   then
      return self.variable == other.variable
        and  self:get_variable_spec() == other:get_variable_spec()
   else
      return false
   end
end

return VariableTerm
