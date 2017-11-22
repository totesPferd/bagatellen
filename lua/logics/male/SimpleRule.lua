local Type =  require "base.type.aux.Type"

local SimpleRule =  Type:__new()


package.loaded["logics.male.SimpleRule"] =  SimpleRule
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function SimpleRule:new()
   local retval =  self:__new()
   return retval
end

function SimpleRule:get_resolve_cast()
end

function SimpleRule:apply(simple_proof_state, goal)
end

function SimpleRule:clone()
end

function SimpleRule:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::male::SimpleRule)"))
end

function SimpleRule:__diagnose_multiple_line(indentation)
   return self:__diagnose_single_line(indentation)
end

return SimpleRule
