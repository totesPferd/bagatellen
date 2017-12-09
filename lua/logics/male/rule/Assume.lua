local Clause =  require "logics.male.Clause"
local Assume =  Clause:__new()

package.loaded["logics.male.rule.Assume"] =  Assume
local Set =  require "base.type.Set"

function Assume:new(literal)
   local premises =  Set:empty_set_factory()
   local var_ctxt =  literal:get_var_ctxt()
   local term =  literal:get_term()
   return Clause.new(self, var_ctxt, premises, term)
end

return Assume
