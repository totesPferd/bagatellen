local SimpleClause =  require "logics.male.SimpleClause"
local Assume =  SimpleClause:__new()

package.loaded["logics.male.simple_rule.Assume"] =  Assume

function Assume:new(literal)
   return SimpleClause.new(self, nil, literal)
end

return Assume
