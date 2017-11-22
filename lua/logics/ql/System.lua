local Type =  require "base.type.aux.Type"

local System =  Type:__new()

package.loaded["logics.ql.System"] =  System
local Compound =  require "logics.ql.Compound"
local MetaVariable =  require "logics.ql.MetaVariable"
local Set =  require "base.type.Set"
local SimpleProofState =  require "logics.ql.SimpleProofState"
local ToLiteral =  require "logics.ql.ToLiteral"

function System:new()
   local retval =  self:__new()
   retval.literals =  Set:empty_set_factory()
   return retval
end

function System:add(qual, d0, d1)
   local lhs_term =  Compound:new(d0, qual)
   local literal =  ToLiteral:new(lhs_term, d1)
   local sps =  SimpleProofState:new(literal)
   sps:add_literal(self.literals)
end

function System:get_normal_form(qual, d0)
   local lhs_term =  Compound:new(d0, qual)
   local rhs_term =  MetaVariable:new(d0)
   local literal =  ToLiteral:new(lhs_term, d1)
   local sps =  SimpleProofState:new(literal)
   sps:normalize(self.literals)
   return rhs_term:get_val()
end

return System
