local Resolve =  require "logics.male.rule.Resolve"

local Td =  Resolve:__new()

package.loaded["logics.ql.rule.Td"] =  Td
local Clause =  require "logics.male.Clause"
local Variable =  require "logics.ql.Variable"
local Set =  require "base.type.Set"
local ToLiteral =  require "logics.ql.ToLiteral"

function Td:new(lhs, hhs)
   local mid_var =  Variable:new()
   local rhs_var =  Variable:new()
   local lhs_var =  Variable:new()
   local lhs_cath =  ToLiteral:new(lhs_var, mid_var)
   local hypoth =  ToLiteral:new(lhs_var, rhs_var)

   local success =  true
   success =  success and lhs:equate(lhs_cath)
   success =  success and hhs:equate(hypoth)

   if success
   then
      local rhs_cath =  ToLiteral:new(mid_var, rhs_var)
      local conclusion =  rhs_cath
      local premises =  Set:empty_set_factory()
      premises:add(lhs_cath)
      premises:add(hypoth)
   
      local clause =  Clause:new(premises, conclusion)
      return Resolve.new(self, clause)
end

function Td:get_refl_cast()
end

function Td:get_trans_cast()
end

function Td:get_td_cast()
   return self
end

return Td
