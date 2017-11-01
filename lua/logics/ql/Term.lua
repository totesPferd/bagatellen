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

function Term:get_variable()
end

function Term:get_qualified(qualifier)
   return Compound:new(self, qualifier)
end

function Term:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::ql::Term)"))
end

function Term:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::ql::Term)"))
end

return Term
