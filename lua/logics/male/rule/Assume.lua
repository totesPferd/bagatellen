local Clause =  require "logics.male.Clause"
local Assume =  Clause:__new()

package.loaded["logics.male.rule.Assume"] =  Assume
local Set =  require "base.type.Set"

function Assume:new(literal)
   local premises =  Set:empty_set_factory()
   return Clause.new(self, premises, literal)
end

return Assume
