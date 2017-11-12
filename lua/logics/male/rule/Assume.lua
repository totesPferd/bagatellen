local Rule =  require "logics.male.Rule"

local Assume =  Rule:__new()


package.loaded["logics.male.rule.Assume"] =  Assume
local Indentation =  require "base.Indentation"
local Set =  require "base.type.Set"
local String =  require "base.type.String"

function Assume:get_assume()
   return self
end

function Assume:apply(dimension, proof_state, goal)
   return proof_state:assume(goal)
end

function Assume:clone()
   return self
end

function Assume:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::male::rule::Assume)"))
end

return Assume
