local Rule =  require "logics.male.Rule"

local Assume =  Rule:__new()


package.loaded["logics.male.rule.Assume"] =  Assume
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function Assume:get_assume()
   return self
end

function Assume:apply(proof_state, goal)
   return proof_state:assume(goal)
end

function Assume:is_blind(prs, proof)
   return false
end

function Assume:__eq(other)
   local retval =  false
   local other_assume =  other.get_assume()
   if other_assume
   then
      retval =  Rule.__eq(self, other_assume)
   end
   return retval
end

function Assume:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics.male.Assume)"))
end

return Assume
