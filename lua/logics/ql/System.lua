local Type =  require "base.type.aux.Type"

local System =  Type:__new()

package.loaded["logics.ql.System"] =  System
local MetaVariable =  require "logics.ql.MetaVariable"
local Set =  require "base.type.Set"
local SimpleProofState =  require "logics.ql.SimpleProofState"
local ToLiteral =  require "logics.ql.ToLiteral"

function System:new()
   local retval =  self:__new()
   retval.literals =  Set:empty_set_factory()
   return retval
end

function System:add(to_literal)
   local sps =  SimpleProofState:new(to_literal)
   sps:add_literal(self.literals)

   for literal in self.literals
   do self.literals:drop(literal)
      sps =  SimpleProofState:new(literal)
      sps:add_literal(self.literals)
   end
end

function System:get_normal_form(base, lhs_term)
   local rhs_term =  MetaVariable:new(base)
   local to_literal =  ToLiteral:new(lhs_term, rhs_term)
   local sps =  SimpleProofState:new(to_literal)
   sps:normalize(self.literals)
   return rhs_term:get_val()
end

return System
