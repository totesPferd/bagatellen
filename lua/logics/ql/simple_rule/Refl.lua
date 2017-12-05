local SimpleClause =  require "logics.male.SimpleClause"
local Refl =  SimpleClause:__new()

package.loaded["logics.ql.simple_rule.refl"] =  Refl
local Variable =  require "logics.ql.Variable"
local ToLiteral =  require "logics.ql.ToLiteral"

function Refl:new()
   local var =  Variable:new(true)
   local conclusion =  ToLiteral:new(var, var)
   return SimpleClause.new(self, nil, conclusion)
end

function Refl:get_refl_cast()
   return self
end

function Refl:get_trans_cast()
end

return Refl
