local Clause =  require "logics.male.Clause"
local Refl =  Clause:__new()

package.loaded["logics.ql.rule.Refl"] =  Refl
local Variable =  require "logics.ql.Variable"
local VariableContext =  require "logics.male.VariableContext"
local Set =  require "base.type.Set"
local ToLiteral =  require "logics.ql.ToLiteral"

function Refl:new()
   local var =  Variable:new()
   local var_ctxt =  VariableContext:new()
   var_ctxt:add_variable(var_ctxt)
   local conclusion =  ToLiteral:new(var, var)
   local premises =  Set:empty_set_factory()
   return Clause.new(self, var_ctxt, premises, conclusion)
end

function Refl:get_refl_cast()
   return self
end

function Refl:get_trans_cast()
end

function Refl:get_td_cast()
end

return Refl
