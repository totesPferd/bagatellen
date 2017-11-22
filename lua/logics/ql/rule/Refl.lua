local Resolve =  require "logics.male.rule.Resolve"

local Refl =  Resolve:__new()

package.loaded["logics.ql.rule.refl"] =  Refl
local Clause =  require "logics.male.Clause"
local ObjectVariable =  require "logics.ql.ObjectVariable"
local Set =  require "base.type.Set"
local ToLiteral =  require "logics.ql.ToLiteral"

function Refl:new()
   local var =  ObjectVariable:new()
   local conclusion =  ToLiteral:new(var, var)
   local premises =  Set:empty_set_factory()
   local clause =  Clause:new(premises, conclusion)
   return Resolve:new(clause)
end

function Refl:get_refl_cast()
   return self
end

function Refl:get_trans_cast()
end

function Refl:get_td_cast()
end

return Refl
