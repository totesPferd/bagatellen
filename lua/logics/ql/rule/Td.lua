local Clause =  require "logics.male.Clause"
local Td =  Clause:__new()

package.loaded["logics.ql.rule.Td"] =  Td
local ContectedTerm =  require "logics.male.ContectedTerm"
local Variable =  require "logics.ql.Variable"
local VariableContext =  require "logics.male.VariableContext"
local Set =  require "base.type.Set"
local ToLiteral =  require "logics.ql.ToLiteral"

function Td:new()
   local mid_var =  Variable:new()
   local rhs_var =  Variable:new()
   local lhs_var =  Variable:new()
   local var_ctxt =  VariableContext:new()
   var_ctxt:add_variable(mid_var)
   var_ctxt:add_variable(rhs_var)
   var_ctxt:add_variable(lhs_var)
   local lhs_cath =  ToLiteral:new(lhs_var, mid_var)
   local hypoth =  ToLiteral:new(lhs_var, rhs_var)

   local rhs_cath =  ToLiteral:new(mid_var, rhs_var)
   local conclusion =  rhs_cath
   local premises =  Set:empty_set_factory()
   premises:add(lhs_cath)
   premises:add(hypoth)

   local retval =  Clause.new(self, var_ctxt, premises, conclusion)
   retval.lhs_premis =  ContectedTerm:new(var_ctxt, lhs_cath)
   retval.hhs_premis =  ContectedTerm:new(var_ctxt, hypoth)
   return retval
end

function Td:get_refl_cast()
end

function Td:get_trans_cast()
end

function Td:get_td_cast()
   return self
end

function Td:get_lhs_premis()
   return self.lhs_premis
end

function Td:get_hhs_premis()
   return self.hhs_premis
end

return Td
