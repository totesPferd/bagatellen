local Resolve =  require "logics.male.rule.Resolve"

local Trans =  Resolve:__new()

package.loaded["logics.ql.rule.Trans"] =  Trans
local Clause =  require "logics.male.Clause"
local Set =  require "base.type.Set"
local ToLiteral =  require "logics.ql.ToLiteral"
local Variable =  require "logics.ql.Variable"

function Trans:new(lhs, rhs)
   local lhs_var =  Variable:new()
   local rhs_var =  Variable:new()
   local mid_var =  Variable:new()
   local lhs_cath =  ToLiteral:new(lhs_var, mid_var)
   local rhs_cath =  ToLiteral:new(mid_var, rhs_var)

   local success =  true
   success =  success and lhs:equate(lhs_cath)
   success =  success and rhs:equate(rhs_cath)

   if success
   then
      local hypoth =  ToLiteral:new(lhs_var, rhs_var)
      local conclusion =  hypoth
      local premises =  Set:empty_set_factory()
      premises:add(lhs_cath)
      premises:add(rhs_cath)
   
      local clause =  Clause:new(premises, conclusion)
      return Resolve.new(self, clause)
   end
end

function Trans:get_refl_cast()
end

function Trans:get_trans_cast()
   return self
end

function Trans:get_td_cast()
end

return Trans
