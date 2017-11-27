local Clause =  require "logics.male.Clause"
local Trans =  Clause:__new()

package.loaded["logics.ql.rule.Trans"] =  Trans
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
   success =  success and lhs_cath:equate(lhs)
   success =  success and rhs_cath:equate(rhs)

   if success
   then
      local hypoth =  ToLiteral:new(lhs_var, rhs_var)
      local conclusion =  hypoth
      local premises =  Set:empty_set_factory()
      premises:add(lhs_cath)
      premises:add(rhs_cath)
   
      local retval =  Clause.new(self, premises, conclusion)
      retval.lhs_premis =  lhs_cath
      retval.rhs_premis =  rhs_cath
      return retval
   end
end

function Trans:get_refl_cast()
end

function Trans:get_trans_cast()
   return self
end

function Trans:get_td_cast()
end

function Trans:get_lhs_premis()
   return self.lhs_premis
end

function Trans:get_rhs_premis()
   return self.rhs_premis
end

return Trans
