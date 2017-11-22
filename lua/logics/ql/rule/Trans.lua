local Resolve =  require "logics.male.rule.Resolve"

local Trans =  Resolve:__new()

package.loaded["logics.ql.rule.refl"] =  Trans
local Clause =  require "logics.male.Clause"
local MetaVariable =  require "logics.ql.MetaVariable"
local ObjectVariable =  require "logics.ql.ObjectVariable"
local Set =  require "base.type.Set"
local ToLiteral =  require "logics.ql.ToLiteral"

function Trans:new()
   local lhs_var =  ObjectVariable:new()
   local rhs_var =  ObjectVariable:new()
   local mid_meta_var =  MetaVariable:new()
   local lhs_cath =  ToLiteral:new(lhs_var, mid_meta_var)
   local rhs_cath =  ToLiteral:new(mid_meta_var, rhs_var)
   local hypoth =  ToLiteral:new(lhs_var, rhs_var)

   local conclusion =  hypoth
   local premises =  Set:empty_set_factory()
   premises:add(lhs_cath)
   premises:add(rhs_cath)

   local clause =  Clause:new(premises, conclusion)
   local retval =  Resolve:new(clause)

   retval.lhs_literal =  lhs_cath
   retval.rhs_literal =  rhs_cath

   return retval
end

function Trans:get_refl_cast()
end

function Trans:get_trans_cast()
   return self
end

function Trans:get_td_cast()
end

function Trans:get_lhs_literal()
   return self.lhs_literal
end

function Trans:get_rhs_literal()
   return self.rhs_literal
end

return Trans
