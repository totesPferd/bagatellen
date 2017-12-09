local Clause =  require "logics.male.Clause"
local Trans =  Clause:__new()

package.loaded["logics.ql.rule.Trans"] =  Trans
local ContectedTerm =  require "logics.male.ContectedTerm"
local Set =  require "base.type.Set"
local ToLiteral =  require "logics.ql.ToLiteral"
local Variable =  require "logics.ql.Variable"
local VariableContext =  require "logics.male.VariableContext"

function Trans:new()
   local lhs_var =  Variable:new()
   local rhs_var =  Variable:new()
   local mid_var =  Variable:new()
   local var_ctxt =  VariableContext:new()
   var_ctxt:add_variable(lhs_var)
   var_ctxt:add_variable(rhs_var)
   var_ctxt:add_variable(mid_var)
   local lhs_cath =  ToLiteral:new(lhs_var, mid_var)
   local rhs_cath =  ToLiteral:new(mid_var, rhs_var)

   local hypoth =  ToLiteral:new(lhs_var, rhs_var)
   local conclusion =  hypoth
   local premises =  Set:empty_set_factory()
   premises:add(lhs_cath)
   premises:add(rhs_cath)

   local retval =  Clause.new(self, var_ctxt, premises, conclusion)
   retval.lhs_premis =  ContectedTerm:new(var_ctxt, lhs_cath)
   retval.rhs_premis =  ContectedTerm:new(var_ctxt, rhs_cath)
   return retval
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
