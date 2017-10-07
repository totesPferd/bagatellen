local Term =  require "logics.pel.Term"

local Skolem =  Term:__new()

package.loaded["logics.pel.term.Skolem"] =  Skolem

function Skolem:new(variable_spec, sort)
   local retval =  Skolem:__new()
   retval.variable_spec =  variable_spec
   retval.sort =  sort
   return retval
end

function Skolem:get_sort()
   return self.sort
end

function Skolem:get_base_term()
   return self.val:get_base_term()
end

function Skolem:set_base_term(term)
   self.val =  term
end

function Skolem:get_skolem()
   return self
end

function Skolem:get_substituted(substitution)
   local val =  self:get_base_term()
   if val
   then
      return val:get_substituted(substitution)
   end
end

return Skolem
