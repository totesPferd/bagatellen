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
   if substitution:is_assigned(self)
   then
      if substitution:deref(self) == term
      then
         return true
      else
         local my_skolem =  term:get_skolem()
         if my_skolem
         then
            if my_skolem:get_base_term() == other:get_base_term()
            then
               substitution:assign(self, term)
            else
               return false
            end
         else
            return self:get_base_term() == other:get_base_term()
         end
      end
   else
      substitution:assign(self, term)
      return true
   end
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
