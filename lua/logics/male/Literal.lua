local Type =  require "base.type.aux.Type"

local Literal =  Type:__new()

package.loaded["logics.male.Literal"] =  Literal

function Literal:get_variable()
end

function Literal:equate(goal)
end

function Literal:devar(var_assgnm)
end

return Literal
