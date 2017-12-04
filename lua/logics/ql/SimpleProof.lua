local MALESimpleProof =  require "logics.male.SimpleProof"
local SimpleProof =  MALESimpleProof:__new()

package.loaded["logics.ql.SimpleProof"] =  SimpleProof
local SimpleProofState =  require "logics.male.SimpleProofState"
local ToLiteral =  require "logics.ql.ToLiteral"
local TransRule =  require "logics.ql.simple_rule.Trans"
local Variable =  require "logics.ql.Variable"

function SimpleProof:new()
   return MALESimpleProof.new(self)
end

function SimpleProof:add_literal(literal)
   local rule =  TransRule:new(literal)
   return self:add_rule(rule)
end

function SimpleProof:add_literals(literals)
   for literal in literals:elems()
   do self:add_literal(literal)
   end
   self:minimize_trs()
end

function SimpleProof:get_normal_form(lhs_term)
   local rhs_term =  Variable:new()
   local to_literal =  ToLiteral:new(lhs_term, rhs_term)
   local sps =  SimpleProofState:new(to_literal)
   sps:apply_proof(self)
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

return SimpleProof
