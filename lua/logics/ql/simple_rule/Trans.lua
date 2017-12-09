local SimpleClause =  require "logics.male.SimpleClause"
local Trans =  SimpleClause:__new()

package.loaded["logics.ql.rule.refl"] =  Trans
local Variable =  require "logics.ql.Variable"
local VariableContext =  require "logics.male.VariableContext"
local ToLiteral =  require "logics.ql.ToLiteral"

function Trans:new(literal)
   local rhs_var =  Variable:new()
   local var_ctxt =  VariableContext:new()
   var_ctxt:add_variable(rhs_var)
   local lhs_term =  literal:get_lhs_term()
   local rhs_term =  literal:get_rhs_term()
   local premis =  ToLiteral:new(rhs_term, rhs_var)
   local conclusion =  ToLiteral:new(lhs_term, rhs_var)

   return SimpleClause.new(self, var_ctxt, premis, conclusion)
end

function Trans:get_refl_cast()
end

function Trans:get_trans_cast()
   return self
end

return Trans
