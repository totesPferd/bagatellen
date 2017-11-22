local Resolve =  require "logics.male.rule.Resolve"

local Assume =  Resolve:__new()

package.loaded["logics.male.rule.Assume"] =  Assume
local Clause =  require "logics.male.Clause"
local Set =  require "base.type.Set"

function Assume:new(literal)
   local premises =  Set:empty_set_factory()
   local clause =  Clause:new(premises, literal)
   return Resolve.new(self, clause)
end

return Assume
