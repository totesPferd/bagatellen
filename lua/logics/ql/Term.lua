local Type =  require "base.type.aux.Type"

local Term =  Type:__new()

package.loaded["logics.ql.Term"] =  Term
local Compound =  require "logics.ql.term.Compound"
local String =  require "base.type.String"
local Substitution =  require "logics.ql.Substitution"

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

function Term:get_base_spec()
end

function Term:get_qualifier()
end

function Term:get_base_concept()
end

function Term:get_compound()
end

function Term:get_skolem()
end

function Term:get_variable()
end

function Term:get_base_term()
   return self
end

function Term:get_qualified(qualifier)
   return Compound:new(self, qualifier)
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
   local other_base_spec =  term:get_base_spec()
   local other_qualifier =  term:get_qualifier()
   local new_qualifier =  other_qualifier:get_rhs_chopped_copy(
      self:get_qualifier() )
   if new_qualifier
   then
      local new_term =  Compound:new(other_base_spec, new_qualifier)
      return self:get_base_spec():_aux_unif(substitution, new_term)
   end
   return false
end

function Term:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::ql::Term)"))
end

function Term:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::ql::Term)"))
end

return Term
