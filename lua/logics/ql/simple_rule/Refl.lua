local Resolve =  require "logics.male.simple_rule.Resolve"

local Refl =  Resolve:__new()

package.loaded["logics.ql.simple_rule.refl"] =  Refl
local ObjectVariable =  require "logics.ql.ObjectVariable"
local ToLiteral =  require "logics.ql.ToLiteral"

function Refl:new()
   local var =  ObjectVariable:new()
   local conclusion =  ToLiteral:new(var, var)
   return Resolve:new(nil, conclusion)
end

function Refl:get_refl_cast()
   return self
end

function Refl:get_trans_cast()
end

return Refl
