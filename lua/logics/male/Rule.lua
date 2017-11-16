local Type =  require "base.type.aux.Type"

local Rule =  Type:__new()


package.loaded["logics.male.Rule"] =  Rule
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function Rule:new()
   local retval =  self:__new()
   return retval
end

function Rule:get_resolve()
end

function Rule:apply(proof_state, goal)
end

function Rule:clone()
end

function Rule:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::male::Rule)"))
end

function Rule:__diagnose_multiple_line(indentation)
   return self:__diagnose_single_line(indentation)
end

return Rule
