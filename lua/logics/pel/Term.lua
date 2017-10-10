local Type =  require "base.type.aux.Type"

local Term =  Type:__new()

package.loaded["logics.pel.Term"] =  Term
local Substitution =  require "logics.pel.Substitution"

function Term:new(variable_spec)
   local retval =  self:__new()
   retval.variable_spec =  variable_spec
   return retval
end

function Term:get_variable_spec()
   return self.variable_spec
end

function Term:get_sort()
end

function Term:get_variable()
end

function Term:get_skolem()
end

function Term:get_compound()
end

function Term:get_base_term()
   return self
end

function Term:get_substituted(substitution)
end

function Term:get_unifier(term)
   local substitution =  Substitution:new(
         term:get_variable_spec()
      ,  self:get_variable_spec() )
   if self:_aux_unif(substitution, term)
   then
      substitution:complete()
      return substitution
   end
end

function Term:_aux_unif(substitution, term)
   return false
end

function Term:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::pel::Term"))
end

function Term:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::pel::Term"))
end

return Term
