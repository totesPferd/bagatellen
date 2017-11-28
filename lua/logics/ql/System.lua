local Type =  require "base.type.aux.Type"

local System =  Type:__new()

package.loaded["logics.ql.System"] =  System
local Set =  require "base.type.Set"
local SimpleProofState =  require "logics.ql.SimpleProofState"
local ToLiteral =  require "logics.ql.ToLiteral"
local Variable =  require "logics.ql.Variable"

function System:new()
   local retval =  self:__new()
   retval.literals =  Set:empty_set_factory()
   return retval
end

function System:add(to_literal)
   local sps =  SimpleProofState:new(to_literal)
   sps:add_literal(self.literals)

   local literals_copy =  self.literals:__clone()
   for literal in literals_copy:elems()
   do self.literals:drop(literal)
      sps =  SimpleProofState:new(literal)
      sps:add_literal(self.literals)
   end
end

function System:get_normal_form(lhs_term)
   local rhs_term =  Variable:new()
   local to_literal =  ToLiteral:new(lhs_term, rhs_term)
   local sps =  SimpleProofState:new(to_literal)
   sps:normalize(self.literals)
   local conclusion =  sps:get_conclusion()
   if conclusion
   then
      local conclusion_to_literal =  conclusion:get_to_literal_cast()
      if conclusion_to_literal
      then
         return conclusion_to_literal:get_lhs_term():get_val()
      end
   end
end

return System
