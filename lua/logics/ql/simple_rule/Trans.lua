local SimpleClause =  require "logics.male.SimpleClause"
local Trans =  SimpleClause:__new()

package.loaded["logics.ql.rule.refl"] =  Trans
local MetaVariable =  require "logics.ql.MetaVariable"
local Variable =  require "logics.ql.Variable"
local ToLiteral =  require "logics.ql.ToLiteral"

function Trans:new(contected_literal)
   local var_ctxt =  contected_literal:get_var_ctxt()
   local rhs_var =  MetaVariable:new()
   local literal =  contected_literal:get_term()
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
