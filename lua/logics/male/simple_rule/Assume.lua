local SimpleClause =  require "logics.male.SimpleClause"
local Assume =  SimpleClause:__new()

package.loaded["logics.male.simple_rule.Assume"] =  Assume

function Assume:new(literal)
   local var_ctxt =  literal:get_var_ctxt()
   local term =  literal:get_term()
   return SimpleClause.new(self, var_ctxt, nil, literal)
end

return Assume
