local Resolve =  require "logics.male.simple_rule.Resolve"

local Trans =  Resolve:__new()

package.loaded["logics.ql.rule.refl"] =  Trans
local ObjectVariable =  require "logics.ql.ObjectVariable"
local ToLiteral =  require "logics.ql.ToLiteral"

function Trans:new(literal)
   local rhs_var =  ObjectVariable:new()
   local lhs_term =  literal:get_lhs_term()
   local rhs_term =  literal:get_rhs_term()
   local premis =  ToLiteral:new(rhs_term, rhs_var)
   local conclusion =  ToLiteral:new(lhs_term, rhs_var)

   local retval =  Resolve:new(premis, conclusion)

   return retval
end

function Trans:get_refl_cast()
end

function Trans:get_trans_cast()
   return self
end

return Trans