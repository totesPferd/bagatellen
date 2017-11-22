local Resolve =  require "logics.male.rule.Resolve"

local Td =  Resolve:__new()

package.loaded["logics.ql.rule.refl"] =  Td
local Clause =  require "logics.male.Clause"
local MetaVariable =  require "logics.ql.MetaVariable"
local ObjectVariable =  require "logics.ql.ObjectVariable"
local Set =  require "base.type.Set"
local ToLiteral =  require "logics.ql.ToLiteral"

function Td:new()
   local lhs_var =  ObjectVariable:new()
   local mid_var =  ObjectVariable:new()
   local rhs_var =  ObjectVariable:new()
   local lhs_meta_var =  MetaVariable:new(mid_var)
   local lhs_cath =  ToLiteral:new(lhs_meta_var, mid_var)
   local rhs_cath =  ToLiteral:new(mid_var, rhs_var)
   local hypoth =  ToLiteral:new(lhs_meta_var, rhs_var)

   local conclusion =  rhs_cath
   local premises =  Set:empty_set_factory()
   premises:add(lhs_cath)
   premises:add(hypoth)

   local clause =  Clause:new(premises, conclusion)
   local retval =  Resolve:new(clause)

   retval.lhs_literal =  lhs_cath
   retval.rhs_literal =  hypoth

   return retval
end

function Td:get_refl_cast()
end

function Td:get_trans_cast()
end

function Td:get_td_cast()
   return self
end

function Td:get_lhs_literal()
   return self.lhs_literal
end

function Td:get_rhs_literal()
   return self.rhs_literal
end

return Td
