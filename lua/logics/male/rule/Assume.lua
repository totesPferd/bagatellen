local Resolve =  require "logics.male.rule.Resolve"
local VarAssgnm =  require "logics.male.VarAssgnm"

local Assume =  Resolve:__new()

package.loaded["logics.male.rule.Assume"] =  Assume
local Clause =  require "logics.male.Clause"
local Set =  require "base.type.Set"

function Assume:new(literal)
   local premises =  Set:empty_set_factory()
   local var_assgnm =  VarAssgnm:new()
   local clause =  Clause:new(premises, literal:devar(var_assgnm))
   return Resolve.new(self, clause)
end

return Assume
